import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_app_2/presentation/model/crop_list.dart';

// Dummy data for demonstration
final List<CropList> cropList = [
  CropList(image: 'assets/agri.jpg', price: '\$10', crop: 'fruit'),
  CropList(image: 'assets/agri2.jpg', price: '\$15', crop: 'vegetable'),
  // Add more crops as needed
];

final cropListProvider = Provider<List<CropList>>((ref) {
  return cropList;
});
