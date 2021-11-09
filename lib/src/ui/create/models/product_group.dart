import 'package:json_annotation/json_annotation.dart';

part 'product_group.g.dart';

@JsonSerializable()
class ProductGroup {
  @JsonKey(name: "descripcion")
  final String description;

  @JsonKey(name: "clave")
  final String code;

  ProductGroup(this.description, this.code);

  factory ProductGroup.fromJson(Map<String, dynamic> json) =>
      _$ProductGroupFromJson(json);
  Map<String, dynamic> toJson() => _$ProductGroupToJson(this);
}
