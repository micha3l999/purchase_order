// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_pending.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersPending _$OrdersPendingFromJson(Map<String, dynamic> json) =>
    OrdersPending(
      json['cdreg'] as String,
      json['nombre'] as String,
      json['tipo'] as String,
    );

Map<String, dynamic> _$OrdersPendingToJson(OrdersPending instance) =>
    <String, dynamic>{
      'cdreg': instance.code,
      'nombre': instance.clientName,
      'tipo': instance.type,
    };
