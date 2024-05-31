class Crop {
  final String? cropId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String cropName;
  final String cropType;
  final String plantingDate;
  final String harvestingDate;
  final String price;
  final int userId;

  Crop({
    this.cropId,
    this.createdAt,
    this.updatedAt,
    required this.cropName,
    required this.cropType,
    required this.plantingDate,
    required this.harvestingDate,
    required this.price,
    required this.userId
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      cropId: json['id']?.toString(),  // Converting id to String if it's not null
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      cropName: json['cropName'],
      cropType: json['cropType'],  // Ensure this matches the field in your JSON
      plantingDate: json['plantingDate'],
      harvestingDate: json['harvestingDate'],
      price: json['price'],
      userId: json['userId'] is String ? int.parse(json['userId']) : json['userId'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': cropId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'cropName': cropName,
      'cropType': cropType,
      'plantingDate': plantingDate,
      'harvestingDate': harvestingDate,
      'price': price,
      'userId': userId,
    };
  }
}
