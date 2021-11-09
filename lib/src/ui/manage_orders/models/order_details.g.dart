// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
      json['cliente'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => ItemDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'cliente': instance.client,
      'items': instance.items,
    };
