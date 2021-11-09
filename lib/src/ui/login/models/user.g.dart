// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['nombre'] as String,
      json['clave'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nombre': instance.name,
      'clave': instance.code,
    };
