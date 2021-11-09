import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(
    genericArgumentFactories: true, fieldRename: FieldRename.snake)
class BaseResponse<T> {
  @JsonKey(name: "datos")
  final List<T> data;

  final String success;

  BaseResponse(this.success, this.data);
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}
