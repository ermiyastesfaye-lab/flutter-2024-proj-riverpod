// ignore_for_file: public_member_api_docs, sort_constructors_first
class UpdateOrderDto {
  final String? orderId;
  final String quantity;

  UpdateOrderDto({
    this.orderId,
    required this.quantity,
  });

  

  factory UpdateOrderDto.fromJson(Map<String, dynamic> json) {
    return UpdateOrderDto(
      orderId: json['id']?.toString(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': orderId,
      'quantity': quantity,
    };
  }
}
