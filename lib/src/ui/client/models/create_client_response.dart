import 'package:json_annotation/json_annotation.dart';

part 'create_client_response.g.dart';

@JsonSerializable()
class CreateClientResponse {
  @JsonKey(name: "codigo")
  final String code;

  CreateClientResponse(this.code);

  factory CreateClientResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateClientResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateClientResponseToJson(this);
}
