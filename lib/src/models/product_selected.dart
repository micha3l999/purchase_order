import 'package:json_annotation/json_annotation.dart';

part 'product_selected.g.dart';

@JsonSerializable()
class ProductSelected {
  final String? code;

  final String? price;

  final String? quantity;

  final String? warehouse;

  final String? image;

  final String? description;

  ProductSelected(this.price, this.code, this.quantity, this.warehouse,
      this.image, this.description);

  factory ProductSelected.fromJson(Map<String, dynamic> json) =>
      _$ProductSelectedFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSelectedToJson(this);
}
