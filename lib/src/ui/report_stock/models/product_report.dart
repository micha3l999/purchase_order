import 'package:json_annotation/json_annotation.dart';

part 'product_report.g.dart';

@JsonSerializable()
class ProductReport {
  @JsonKey(name: "codigo")
  final String code;

  @JsonKey(name: "bodega")
  final String warehouse;

  @JsonKey(name: "descrip")
  final String description;

  @JsonKey(name: "stock")
  final String stock;

  @JsonKey(name: "precio1")
  final String price1;

  @JsonKey(name: "precio2")
  final String price2;

  @JsonKey(name: "precio3")
  final String price3;

  @JsonKey(name: "precio4")
  final String price4;

  @JsonKey(name: "imagen")
  final String image;

  ProductReport(this.code, this.warehouse, this.description, this.stock,
      this.price1, this.price2, this.price3, this.price4, this.image);

  factory ProductReport.fromJson(Map<String, dynamic> json) =>
      _$ProductReportFromJson(json);
  Map<String, dynamic> toJson() => _$ProductReportToJson(this);
}
