// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      contentType: json['contentType'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String? ?? '',
      htmlText: json['htmlText'] as String? ?? '',
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'contentType': instance.contentType,
      'videoUrl': instance.videoUrl,
      'pictureUrl': instance.pictureUrl,
      'htmlText': instance.htmlText,
    };

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
      id: json['id'] as String? ?? Uuid.NAMESPACE_DNS,
      creatorName: json['creatorName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: Content.fromJson(json['content'] as Map<String, dynamic>),
      likesCount: json['likesCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
    );

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
      'id': instance.id,
      'creatorName': instance.creatorName,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'viewsCount': instance.viewsCount,
      'commentsCount': instance.commentsCount,
    };
