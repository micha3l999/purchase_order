// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      json['codigo'] as String?,
      json['nombre'] as String?,
      json['direcc'] as String?,
      json['telef'] as String?,
      json['email'] as String?,
      json['identification'] as String?,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'codigo': instance.code,
      'nombre': instance.name,
      'direcc': instance.address,
      'telef': instance.telephone,
      'email': instance.email,
      'identification': instance.identification,
    };
