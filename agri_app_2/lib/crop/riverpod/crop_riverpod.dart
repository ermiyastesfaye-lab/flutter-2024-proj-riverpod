import 'package:agri_app_2/crop/data_provider/crop_data_provider.dart';
import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:agri_app_2/crop/model/update_crop_model.dart';
import 'package:agri_app_2/crop/repository/crop_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the event classes
class CreateCropEvent {
  final Crop crop;

  CreateCropEvent({required this.crop});
}

class DeleteCropEvent {
  final String? cropId;

  DeleteCropEvent({required this.cropId});
}

class UpdateCropEvent {
  final String cropId;
  final UpdateCropDto crop;

  UpdateCropEvent({required this.cropId, required this.crop});
}

class GetCropsByIdEvent {
  final int cropId;

  GetCropsByIdEvent({required this.cropId});
}

class GetCropsEvent {}

class GetOrderCropsEvent {}

// Define the state classes
abstract class CropState {}

class CropInitialState extends CropState {}

class CropLoadingState extends CropState {}

class CropLoadedState extends CropState {
  final List<Crop> crops;

  CropLoadedState(this.crops);
}

class CropsLoadingState extends CropState {}

class CropSuccessState extends CropState {
  final String message;

  CropSuccessState(this.message);
}

class CropErrorState extends CropState {
  final String error;

  CropErrorState(this.error);
}

// Define the provider
final cropProvider = StateNotifierProvider<CropNotifier, CropState>(
  (ref) => CropNotifier(ref.watch(cropRepositoryProvider)),
);

// Define the notifier class
class CropNotifier extends StateNotifier<CropState> {
  final CropRepository _cropRepository;

  CropNotifier(this._cropRepository) : super(CropInitialState());

  Future<void> createCrop(CreateCropEvent event) async {
    try {
      state = CropLoadingState();
      await _cropRepository.createCrop(event.crop);
      state = CropSuccessState("Crop created successfully!");
    } catch (error) {
      state = CropErrorState(error.toString());
    }
  }

  Future<void> deleteCrop(DeleteCropEvent event) async {
    try {
      state = CropLoadingState();
      await _cropRepository.deleteCrop(event.cropId);
      state = CropSuccessState("Crop deleted successfully!");
    } catch (error) {
      state = CropErrorState(error.toString());
    }
  }

  Future<void> updateCrop(UpdateCropEvent event) async {
    try {
      state = CropLoadingState();
      await _cropRepository.updateCrop(event.cropId, event.crop);
      state = CropSuccessState("Crop updated successfully!");
    } catch (error) {
      state = CropErrorState(error.toString());
    }
  }

  Future<void> getCropById(GetCropsByIdEvent event) async {
    try {
      state = CropLoadingState();
      final crops = await _cropRepository.getCropById(event.cropId);
      state = CropLoadedState(crops);
    } catch (error) {
      state = CropErrorState(error.toString());
    }
  }

  Future<void> getCrops() async {
    try {
      state = CropsLoadingState();
      final crops = await _cropRepository.getCrops();
      state = CropLoadedState(crops);
    } catch (error) {
      state = CropErrorState(error.toString());
    }
  }

  Future<void> getOrderCrops() async {
    try {
      state = CropsLoadingState();
      final crops = await _cropRepository.getOrderCrops();
      state = CropLoadedState(crops);
    } catch (error) {
      state = CropErrorState(error.toString());
    }
  }
}

// Define the shared preferences provider
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Define the data provider
final cropDataProviderProvider = Provider<CropDataProvider>((ref) {
  final dio = Dio();
  final sharedPreferences = ref.watch(sharedPreferencesProvider.future);
  return CropDataProvider(dio, sharedPreferences as SharedPreferences);
});

// Define the repository provider
final cropRepositoryProvider = Provider<CropRepository>((ref) {
  return ConcreteCropRepository(ref.watch(cropDataProviderProvider));
});
