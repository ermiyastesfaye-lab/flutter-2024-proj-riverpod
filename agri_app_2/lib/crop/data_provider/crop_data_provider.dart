import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:agri_app_2/crop/model/update_crop_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CropDataProvider {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  CropDataProvider(this.dio, this.sharedPreferences);

  Future<Map<String, String>> _authenticatedHeaders() async {
    final token = sharedPreferences.getString('token');

    if (token == null) {
      throw Exception('Missing token in local storage.');
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Assuming JSON content type
    };
  }

  Future<Crop> createCrop(Crop crop) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.post('http://localhost:3000/crops',
          data: crop.toJson(), options: Options(headers: headers));

      if (response.statusCode == 201) {
        final data = response.data;
        return Crop.fromJson(data);
      } else {
        throw Exception('Failed to create Crop');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteCrop(String? cropId) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.delete('http://localhost:3000/crops/$cropId',
          options: Options(headers: headers));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete Crop');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<UpdateCropDto> updateCrop(String cropId, UpdateCropDto crop) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.patch('http://localhost:3000/crops/$cropId',
          data: crop.toJson(), options: Options(headers: headers));

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        return UpdateCropDto.fromJson(data);
      } else {
        print("error");
        throw Exception('Failed to update Crop');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Crop>> getCropById(int cropId) async {
    try {
      final headers = await _authenticatedHeaders();
      final response = await dio.get(
        'http://localhost:3000/crops/$cropId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((cropJson) => Crop.fromJson(cropJson)).toList();
      } else {
        throw Exception('Failed to get Crops for user');
      }
    } catch (error) {
      rethrow;
    }
  }

 Future<List<Crop>> getCrops() async {
  try {
    final headers = await _authenticatedHeaders();
    final response = await dio.get('http://localhost:3000/crops',
        options: Options(headers: headers));

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data; // Directly use response.data
      return data.map((json) => Crop.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get Crops');
    }
  } catch (error) {
    print('Error: $error');  // Debugging: print the error
    rethrow;
  }
}

Future<List<Crop>> getOrderCrops() async {
  final dio = Dio();

  try {
     final headers = await _authenticatedHeaders();
    final response = await dio.get('http://localhost:3000/crops/all-crops',
      options: Options(headers: headers));

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Crop.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get crops');
    }
  } catch (error) {
    print('Error: $error');
    rethrow;
  }
}
}
