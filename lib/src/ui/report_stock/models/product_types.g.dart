// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductTypes _$ProductTypesFromJson(Map<String, dynamic> json) => ProductTypes(
      json['clave'] as String,
      json['descripcion'] as String,
    );

Map<String, dynamic> _$ProductTypesToJson(ProductTypes instance) =>
    <String, dynamic>{
      'clave': instance.code,
      'descripcion': instance.description,
    };
