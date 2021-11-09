import 'package:json_annotation/json_annotation.dart';
import 'package:purchase_order/src/ui/manage_orders/models/item_details.dart';

part 'order_details.g.dart';

@JsonSerializable()
class OrderDetails {
  OrderDetails(this.client, this.items);

  @JsonKey(name: "cliente")
  late final String client;

  late final List<ItemDetails> items;

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}
