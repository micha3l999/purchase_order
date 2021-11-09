import 'package:json_annotation/json_annotation.dart';

part 'product_types.g.dart';

@JsonSerializable()
class ProductTypes {
  @JsonKey(name: "clave")
  final String code;

  @JsonKey(name: "descripcion")
  final String description;

  ProductTypes(this.code, this.description);

  factory ProductTypes.fromJson(Map<String, dynamic> json) =>
      _$ProductTypesFromJson(json);
  Map<String, dynamic> toJson() => _$ProductTypesToJson(this);
}
