import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/widget/logo.dart';
import 'package:agri_app_2/presentation/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:agri_app_2/presentation/widget/app_bar.dart';
import 'package:agri_app_2/presentation/widget/menu_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_app_2/providers/form_provider.dart'; // Import the provider

class AddCrop extends ConsumerWidget {
  const AddCrop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropForm = ref.watch(cropFormProvider);

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
                      color: myColor.tertiary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    context,
                    label: 'Crop Name',
                    value: cropForm.cropName,
                    onChanged: (value) {
                      ref.read(cropFormProvider.notifier).updateCropName(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    context,
                    label: 'Crop Type',
                    value: cropForm.cropType,
                    onChanged: (value) {
                      // Update crop type using provider
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    context,
                    label: 'Planting Date',
                    value: cropForm.plantingDate,
                    onChanged: (value) {
                      // Update planting date using provider
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    context,
                    label: 'Harvesting Date',
                    value: cropForm.harvestingDate,
                    onChanged: (value) {
                      // Update harvesting date using provider
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    context,
                    label: 'Price(ETB)',
                    value: cropForm.price,
                    onChanged: (value) {
                      // Update price using provider
                    },
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/cropManagement');
                        },
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String value,
    required void Function(String) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: myColor.tertiary),
        ),
        SizedBox(
          width: 200,
          height: 35,
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: myColor.primary),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
