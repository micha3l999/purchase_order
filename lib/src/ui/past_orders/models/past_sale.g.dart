// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PastSale _$PastSaleFromJson(Map<String, dynamic> json) => PastSale(
      json['cdreg'] as String,
      json['nombre'] as String,
      json['tipo'] as String,
      json['total'] as String,
    );

Map<String, dynamic> _$PastSaleToJson(PastSale instance) => <String, dynamic>{
      'cdreg': instance.code,
      'nombre': instance.clientName,
      'tipo': instance.type,
      'total': instance.total,
    };
