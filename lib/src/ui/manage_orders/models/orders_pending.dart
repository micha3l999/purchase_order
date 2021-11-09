import 'package:json_annotation/json_annotation.dart';

part 'orders_pending.g.dart';

@JsonSerializable()
class OrdersPending {
  @JsonKey(name: "cdreg")
  final String code;

  @JsonKey(name: "nombre")
  final String clientName;

  @JsonKey(name: "tipo")
  final String type;

  OrdersPending(this.code, this.clientName, this.type);

  factory OrdersPending.fromJson(Map<String, dynamic> json) =>
      _$OrdersPendingFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersPendingToJson(this);
}
