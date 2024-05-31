import 'package:agri_app_2/crop/data_provider/crop_data_provider.dart';
import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:agri_app_2/crop/model/update_crop_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the abstract repository interface
abstract class CropRepository {
  CropRepository(CropDataProvider cropDataProvider);

  Future<Crop> createCrop(Crop crop);
  Future<void> deleteCrop(String? cropId);
  Future<UpdateCropDto> updateCrop(String cropId, UpdateCropDto crop);
  Future<List<Crop>> getCropById(int cropId);
  Future<List<Crop>> getCrops();
  Future<List<Crop>> getOrderCrops();
}

// Define the concrete repository implementation
class ConcreteCropRepository implements CropRepository {
  final CropDataProvider _cropDataProvider;

  ConcreteCropRepository(this._cropDataProvider);

  @override
  Future<Crop> createCrop(Crop crop) async {
    return await _cropDataProvider.createCrop(crop);
  }

  @override
  Future<void> deleteCrop(String? cropId) async {
    return await _cropDataProvider.deleteCrop(cropId);
  }

  @override
  Future<UpdateCropDto> updateCrop(String cropId, UpdateCropDto crop) async {
    return await _cropDataProvider.updateCrop(cropId, crop);
  }

  @override
  Future<List<Crop>> getCropById(int cropId) async {
    return await _cropDataProvider.getCropById(cropId);
  }

  @override
  Future<List<Crop>> getCrops() async {
    return await _cropDataProvider.getCrops();
  }

  @override
  Future<List<Crop>> getOrderCrops() async {
    return await _cropDataProvider.getOrderCrops();
  }
}

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

// Define the shared preferences provider
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
