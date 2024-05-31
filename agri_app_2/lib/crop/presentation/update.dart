import 'package:agri_app_2/crop/data_provider/crop_data_provider.dart';
import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:agri_app_2/crop/model/update_crop_model.dart';
import 'package:agri_app_2/crop/presentation/add_crop.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:agri_app_2/presentation/widget/crop_management_list.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cropProvider =
    StateNotifierProvider<CropNotifier, AsyncValue<List<Crop>>>(
  (ref) => CropNotifier(ref.watch(cropRepositoryProvider)),
);

class CropNotifier extends StateNotifier<AsyncValue<List<Crop>>> {
  final CropRepository _cropRepository;

  CropNotifier(this._cropRepository) : super(const AsyncValue.loading());

  Future<void> fetchCrops() async {
    try {
      final crops = await _cropRepository.getCrops();
      state = AsyncValue.data(crops);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteCrop(String cropId) async {
    try {
      await _cropRepository.deleteCrop(cropId);
      await fetchCrops();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateCrop(String cropId, UpdateCropDto updatedCrop) async {
    try {
      await _cropRepository.updateCrop(cropId, updatedCrop);
      await fetchCrops();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

class CropMangement extends ConsumerWidget {
  const CropMangement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropsAsync = ref.watch(cropProvider);
    return Scaffold(
      appBar: const AppBarWidget(),
      drawer: const MenuBarWidget(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxWidth: 700.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: LogoWidget(logo: logos[0]),
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddCrop()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColor.secondary,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 15),
                      Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: myColor.tertiary,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: cropsAsync.when(
                data: (crops) {
                  return GridView.count(
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      for (final crop in crops) CropListManagement(crop: crop)
                    ],
                  );
                },
                error: (error, stackTrace) {
                  return Center(child: Text('Error: $error'));
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }

  Widget gridItem(String imagePath, String name, int amount) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10.0),
              Text(
                '${amount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdatePage extends ConsumerStatefulWidget {
  final String? cropId;
  final Crop crop;

  const UpdatePage({
    super.key,
    required this.cropId,
    required this.crop,
  });

  @override
  ConsumerState<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {
  late TextEditingController _cropNameController;
  late TextEditingController _cropTypeController;
  late TextEditingController _plantingDateController;
  late TextEditingController _harvestingDateController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _cropNameController = TextEditingController(text: widget.crop.cropName);
    _cropTypeController = TextEditingController(text: widget.crop.cropType);
    _plantingDateController =
        TextEditingController(text: widget.crop.plantingDate);
    _harvestingDateController =
        TextEditingController(text: widget.crop.harvestingDate);
    _priceController = TextEditingController(text: widget.crop.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      drawer: const MenuBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Opacity(
              opacity: 0.5,
              child: IgnorePointer(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19, vertical: 10),
                        child: LogoWidget(logo: logos[0]),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                myColor.secondary, // Background color
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(15),
              height: 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 246, 246, 246),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crop Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: myColor.tertiary),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Crop Name',
                        style: TextStyle(fontSize: 16, color: myColor.tertiary),
                      ),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: TextField(
                          controller: _cropNameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: widget.crop.cropName,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Crop Type',
                        style: TextStyle(fontSize: 16, color: myColor.tertiary),
                      ),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: TextField(
                          controller: _cropTypeController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: widget.crop.cropType,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Planting Date',
                        style: TextStyle(fontSize: 16, color: myColor.tertiary),
                      ),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: TextField(
                          controller: _plantingDateController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: widget.crop.plantingDate,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Harvesting Date',
                        style: TextStyle(fontSize: 16, color: myColor.tertiary),
                      ),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: TextField(
                          controller: _harvestingDateController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: widget.crop.harvestingDate,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price(ETB)',
                        style: TextStyle(fontSize: 16, color: myColor.tertiary),
                      ),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: TextField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: widget.crop.price,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateCrop(context, ref);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myColor.secondary,
                          // Background color
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }

  void _updateCrop(BuildContext context, WidgetRef ref) {
    final updatedCrop = UpdateCropDto(
      cropName: _cropNameController.text,
      cropType: _cropTypeController.text,
      plantingDate: _plantingDateController.text,
      harvestingDate: _harvestingDateController.text,
      price: _priceController.text,
    );

    ref.read(cropProvider.notifier).updateCrop(
          widget.cropId!,
          updatedCrop,
        );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Crop updated Successfully'),
            content: const Text('Your Crop has been updated successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CropMangement()));
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _cropTypeController.dispose();
    _plantingDateController.dispose();
    _harvestingDateController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}

// Define the abstract repository interface
abstract class CropRepository {
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
