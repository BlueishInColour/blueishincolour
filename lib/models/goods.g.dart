// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Good _$GoodFromJson(Map<String, dynamic> json) => Good(
      albumId: (json['albumId'] as num?)?.toDouble() ?? 0,
      goodId: json['goodId'] as String? ?? '',
      description: json['description'] as String? ?? '',
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      stock: (json['stock'] as num?)?.toDouble() ?? 0,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      listOfLikers: (json['listOfLikers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GoodToJson(Good instance) => <String, dynamic>{
      'listOfLikers': instance.listOfLikers,
      'albumId': instance.albumId,
      'goodId': instance.goodId,
      'thumbnail': instance.thumbnail,
      'title': instance.title,
      'description': instance.description,
      'discountPercentage': instance.discountPercentage,
      'stock': instance.stock,
      'price': instance.price,
      'category': instance.category,
      'brand': instance.brand,
      'rating': instance.rating,
      'images': instance.images,
    };

Every _$EveryFromJson(Map<String, dynamic> json) => Every(
      products: (json['products'] as List<dynamic>)
          .map((e) => Good.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: (json['limit'] as num?)?.toDouble() ?? 0,
      skip: (json['skip'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$EveryToJson(Every instance) => <String, dynamic>{
      'products': instance.products,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };
