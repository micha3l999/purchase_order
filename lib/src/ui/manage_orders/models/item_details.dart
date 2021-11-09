import 'package:json_annotation/json_annotation.dart';

part 'item_details.g.dart';

@JsonSerializable()
class ItemDetails {
  ItemDetails(this.product, this.quantity, this.unitValue, this.ivaPrice,
      this.total, this.subtotal);

  @JsonKey(name: "producto")
  late final String product;

  @JsonKey(name: "cantidad")
  late final String quantity;

  @JsonKey(name: "valor_prec")
  late final String unitValue;

  @JsonKey(name: "valor_iva")
  late final String ivaPrice;

  late final String total;

  late final String subtotal;

  factory ItemDetails.fromJson(Map<String, dynamic> json) =>
      _$ItemDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDetailsToJson(this);
}
