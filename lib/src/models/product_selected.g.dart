// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_selected.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSelected _$ProductSelectedFromJson(Map<String, dynamic> json) =>
    ProductSelected(
      json['price'] as String?,
      json['code'] as String?,
      json['quantity'] as String?,
      json['warehouse'] as String?,
      json['image'] as String?,
      json['description'] as String?,
    );

Map<String, dynamic> _$ProductSelectedToJson(ProductSelected instance) =>
    <String, dynamic>{
      'code': instance.code,
      'price': instance.price,
      'quantity': instance.quantity,
      'warehouse': instance.warehouse,
      'image': instance.image,
      'description': instance.description,
    };
