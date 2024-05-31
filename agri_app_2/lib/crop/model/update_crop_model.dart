class UpdateCropDto {
  final String? cropId;
  final String cropName;
  final String cropType;
  final String plantingDate;
  final String harvestingDate;
  final String price;

  UpdateCropDto({
    this.cropId,
    required this.cropName,
    required this.cropType,
    required this.plantingDate,
    required this.harvestingDate,
    required this.price,
  });
  

  factory UpdateCropDto.fromJson(Map<String, dynamic> json) {
    return UpdateCropDto(
      cropId: json['id']?.toString(),
      cropName: json['cropName'],
      cropType: json['cropType'], 
      plantingDate: json['plantingDate'],
      harvestingDate: json['harvestingDate'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': cropId,
      'cropName': cropName,
      'cropType': cropType,
      'plantingDate': plantingDate,
      'harvestingDate': harvestingDate,
      'price': price,
    };
  }
}
