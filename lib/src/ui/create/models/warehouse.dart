import 'package:json_annotation/json_annotation.dart';

part 'warehouse.g.dart';

@JsonSerializable()
class Warehouse {
  @JsonKey(name: "descripcion")
  final String description;

  @JsonKey(name: "clave")
  final String code;

  Warehouse(this.description, this.code);

  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseToJson(this);
}
