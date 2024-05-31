// ignore_for_file: public_member_api_docs, sort_constructors_first
class Order {
  final String? cropId;
  final String? orderId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String quantity;
  final String? cropName;
  final String? cropType;
  final String? plantingDate;
  final String? harvestingDate;
  final String? price;
  final int? userId;

  Order({
    this.cropId,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    required this.quantity,
    this.cropName,
    this.cropType,
    this.plantingDate,
    this.harvestingDate,
    this.price,
    this.userId,
  });
  

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order( 
      orderId: json['id']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      quantity: json['quantity'].toString(),
      cropName: json['cropName'],
      cropType: json['cropType'],
      plantingDate: json['plantingDate'],
      harvestingDate: json['harvestingDate'],
      price: json['price']?.toString(),
      userId: json['userId'] is String ? int.parse(json['userId']) : json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropId': cropId,
      'quantity': quantity

    };
  }
}
