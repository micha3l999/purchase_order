// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['codigo'] as String,
      json['descrip'] as String,
      json['stock'] as String,
      json['imagen'] as String,
      json['precio1'] as String?,
      json['precio2'] as String?,
      json['precio3'] as String?,
      json['precio4'] as String?,
      json['precio5'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'codigo': instance.code,
      'descrip': instance.description,
      'stock': instance.stock,
      'imagen': instance.image,
      'precio1': instance.price1,
      'precio2': instance.price2,
      'precio3': instance.price3,
      'precio4': instance.price4,
      'precio5': instance.price5,
    };
