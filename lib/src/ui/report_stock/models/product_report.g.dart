// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReport _$ProductReportFromJson(Map<String, dynamic> json) =>
    ProductReport(
      json['codigo'] as String,
      json['bodega'] as String,
      json['descrip'] as String,
      json['stock'] as String,
      json['precio1'] as String,
      json['precio2'] as String,
      json['precio3'] as String,
      json['precio4'] as String,
      json['imagen'] as String,
    );

Map<String, dynamic> _$ProductReportToJson(ProductReport instance) =>
    <String, dynamic>{
      'codigo': instance.code,
      'bodega': instance.warehouse,
      'descrip': instance.description,
      'stock': instance.stock,
      'precio1': instance.price1,
      'precio2': instance.price2,
      'precio3': instance.price3,
      'precio4': instance.price4,
      'imagen': instance.image,
    };
