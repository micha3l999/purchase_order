// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warehouse _$WarehouseFromJson(Map<String, dynamic> json) => Warehouse(
      json['descripcion'] as String,
      json['clave'] as String,
    );

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) => <String, dynamic>{
      'descripcion': instance.description,
      'clave': instance.code,
    };
