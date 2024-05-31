import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:agri_app_2/crop/presentation/crop_management.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider for managing crop state
final cropProvider = StateNotifierProvider<CropNotifier, List<Crop>>((ref) {
  return CropNotifier();
});

// CropNotifier class to handle state updates
class CropNotifier extends StateNotifier<List<Crop>> {
  CropNotifier() : super([]);

  void addCrop(Crop crop) {
    state = [...state, crop];
  }
}

class AddCrop extends ConsumerStatefulWidget {
  const AddCrop({super.key});

  @override
  _AddCropState createState() => _AddCropState();
}

class _AddCropState extends ConsumerState<AddCrop> {
  final _formKey = GlobalKey<FormState>();
  final _cropNameController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _plantingDateController = TextEditingController();
  final _harvestingDateController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _cropNameController.dispose();
    _cropTypeController.dispose();
    _plantingDateController.dispose();
    _harvestingDateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submitCrop() async {
    if (_formKey.currentState!.validate()) {
      final sharedPreferences = await SharedPreferences.getInstance();
      final userId = sharedPreferences.getInt('userId');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User ID not found. Please log in again.'),
          ),
        );
        return;
      }

      final crop = Crop(
        cropName: _cropNameController.text,
        cropType: _cropTypeController.text,
        plantingDate: _plantingDateController.text,
        harvestingDate: _harvestingDateController.text,
        price: _priceController.text,
        userId: userId,
      );

      ref.read(cropProvider.notifier).addCrop(crop);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Crop Created Successfully'),
            content: const Text('Your Crop has been created successfully.'),
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
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(),
        drawer: const MenuBarWidget(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  )),
                ),
                const SizedBox(
                  height: 40,
                ),
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
                          color: myColor.tertiary,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Crop Name',
                            style: TextStyle(
                              fontSize: 16,
                              color: myColor.tertiary,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 35,
                            child: TextFormField(
                              controller: _cropNameController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: myColor.primary),
                                borderRadius: BorderRadius.circular(10),
                              )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter crop name';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Crop Type',
                            style: TextStyle(
                                fontSize: 16, color: myColor.tertiary),
                          ),
                          SizedBox(
                            width: 200,
                            height: 35,
                            child: TextFormField(
                              controller: _cropTypeController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: myColor.primary),
                                borderRadius: BorderRadius.circular(10),
                              )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter crop type';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Planting Date',
                            style: TextStyle(
                              fontSize: 16,
                              color: myColor.tertiary,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 35,
                            child: TextFormField(
                              controller: _plantingDateController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: myColor.primary),
                                borderRadius: BorderRadius.circular(10),
                              )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter planting date';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Harvesting Date',
                            style: TextStyle(
                              fontSize: 16,
                              color: myColor.tertiary,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            height: 35,
                            child: TextFormField(
                              controller: _harvestingDateController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: myColor.primary),
                                borderRadius: BorderRadius.circular(10),
                              )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter harvesting date';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price(ETB)',
                            style: TextStyle(
                                fontSize: 16, color: myColor.tertiary),
                          ),
                          SizedBox(
                            width: 200,
                            height: 35,
                            child: TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: myColor.primary),
                                borderRadius: BorderRadius.circular(10),
                              )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter price';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: _submitCrop,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    myColor.secondary // Background color
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBarWidget());
  }
}
