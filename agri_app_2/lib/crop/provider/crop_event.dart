

import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:agri_app_2/crop/model/update_crop_model.dart';

abstract class CropEvent {
  const CropEvent();
}

class LoadCropsEvent extends CropEvent {
  const LoadCropsEvent();
}

class CreateCropEvent extends CropEvent {
  final Crop crop;

  const CreateCropEvent(this.crop);
}

class DeleteCropEvent extends CropEvent {
  final String? cropId;

  const DeleteCropEvent(this.cropId);
}

class UpdateCropEvent extends CropEvent {
  final String cropId;
  final UpdateCropDto crop;

  UpdateCropEvent({required this.cropId, required this.crop});

  List<Object> get props => [cropId, crop];
}

class GetCropsByIdEvent extends CropEvent {
  final int cropId;
  GetCropsByIdEvent({
    required this.cropId,
  });
}

class GetCropsEvent extends CropEvent {
  const GetCropsEvent();
}

class GetOrderCropsEvent extends CropEvent {
  const GetOrderCropsEvent();
}
