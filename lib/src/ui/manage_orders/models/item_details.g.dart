// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemDetails _$ItemDetailsFromJson(Map<String, dynamic> json) => ItemDetails(
      json['producto'] as String,
      json['cantidad'] as String,
      json['valor_prec'] as String,
      json['valor_iva'] as String,
      json['total'] as String,
      json['subtotal'] as String,
    );

Map<String, dynamic> _$ItemDetailsToJson(ItemDetails instance) =>
    <String, dynamic>{
      'producto': instance.product,
      'cantidad': instance.quantity,
      'valor_prec': instance.unitValue,
      'valor_iva': instance.ivaPrice,
      'total': instance.total,
      'subtotal': instance.subtotal,
    };
