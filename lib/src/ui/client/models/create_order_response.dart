import 'package:json_annotation/json_annotation.dart';

part 'create_order_response.g.dart';

@JsonSerializable()
class CreateOrderResponse {
  @JsonKey(name: "codigo")
  final String code;

  CreateOrderResponse(this.code);

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);
}
