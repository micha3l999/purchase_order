// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductGroup _$ProductGroupFromJson(Map<String, dynamic> json) => ProductGroup(
      json['descripcion'] as String,
      json['clave'] as String,
    );

Map<String, dynamic> _$ProductGroupToJson(ProductGroup instance) =>
    <String, dynamic>{
      'descripcion': instance.description,
      'clave': instance.code,
    };
