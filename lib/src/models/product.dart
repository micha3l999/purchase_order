import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "codigo")
  final String code;

  @JsonKey(name: "descrip")
  final String description;

  @JsonKey(name: "stock")
  final String stock;

  @JsonKey(name: "imagen")
  final String image;

  @JsonKey(name: "precio1")
  String? price1;

  @JsonKey(name: "precio2")
  final String? price2;

  @JsonKey(name: "precio3")
  final String? price3;

  @JsonKey(name: "precio4")
  final String? price4;

  @JsonKey(name: "precio5")
  final String? price5;

  @JsonKey(name: "precio6")
  final String? price6;

  Product(this.code, this.description, this.stock, this.image, this.price1,
      this.price2, this.price3, this.price4, this.price5, this.price6);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
