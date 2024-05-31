import 'package:agri_app_2/crop/model/crop_model.dart';
import 'package:equatable/equatable.dart';

abstract class CropState extends Equatable {
  const CropState();

  @override
  List<Object?> get props => [];
}

class CropInitialState extends CropState {}

class CropLoadingState extends CropState {}

class CropLoadedState extends CropState {
  final List<Crop> crops;

  const CropLoadedState(this.crops);

  @override
  List<Object?> get props => [crops];
}

class CropErrorState extends CropState {
  final String message;

  const CropErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class CropSuccessState extends CropState {
  final String message;

  const CropSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class CropsLoadingState extends CropState {
  const CropsLoadingState();

  @override
  List<Object?> get props => [];
}