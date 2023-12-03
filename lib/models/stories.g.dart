// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
      creatorName: json['creatorName'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      reactions: json['reactions'] as int? ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
      'userId': instance.userId,
      'creatorName': instance.creatorName,
      'title': instance.title,
      'tags': instance.tags,
      'reactions': instance.reactions,
      'body': instance.body,
    };
