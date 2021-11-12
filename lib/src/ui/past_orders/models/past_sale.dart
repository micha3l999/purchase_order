import 'package:json_annotation/json_annotation.dart';

part 'past_sale.g.dart';

@JsonSerializable()
class PastSale {
  @JsonKey(name: "cdreg")
  final String code;

  @JsonKey(name: "nombre")
  final String clientName;

  @JsonKey(name: "tipo")
  final String type;

  final String total;

  PastSale(this.code, this.clientName, this.type, this.total);

  factory PastSale.fromJson(Map<String, dynamic> json) =>
      _$PastSaleFromJson(json);
  Map<String, dynamic> toJson() => _$PastSaleToJson(this);
}
