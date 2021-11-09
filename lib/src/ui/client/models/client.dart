import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  @JsonKey(name: "codigo")
  final String? code;

  @JsonKey(name: "nombre")
  final String? name;

  @JsonKey(name: "direcc")
  final String? address;

  @JsonKey(name: "telef")
  final String? telephone;

  @JsonKey(name: "email")
  final String? email;

  // this field is just to complete the proforma
  String? identification;

  Client(this.code, this.name,
      [this.address, this.telephone, this.email, this.identification]);

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
