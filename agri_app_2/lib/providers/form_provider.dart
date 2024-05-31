// form_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CropForm {
  final String cropName;
  final String cropType;
  final String plantingDate;
  final String harvestingDate;
  final String price;

  CropForm({
    this.cropName = '',
    this.cropType = '',
    this.plantingDate = '',
    this.harvestingDate = '',
    this.price = '',
  });
}

class CropFormNotifier extends StateNotifier<CropForm> {
  CropFormNotifier() : super(CropForm());

  void updateCropName(String name) {
    state = CropForm(cropName: name);
  }

  // Similarly, add methods to update other fields
}

final cropFormProvider = StateNotifierProvider<CropFormNotifier, CropForm>(
  (ref) => CropFormNotifier(),
);
