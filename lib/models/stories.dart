import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'stories.g.dart';

@JsonSerializable()
class Content {
  Content(
      {this.contentType = '',
      this.videoUrl = '',
      this.pictureUrl = '',
      this.htmlText = ''});

  String contentType;
  String videoUrl;
  String pictureUrl;
  String htmlText;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable()
class Stories {
  Stories({
    this.id = Uuid.NAMESPACE_DNS,
    //
    this.creatorName = '',

    //
    this.title = '',
    this.description = '',
    //
    required this.content,
//counts
    this.likesCount = 0,
    this.viewsCount = 0,
    this.commentsCount = 0,

    //
  });
  //id
  String id;

  //creator
  String creatorName;

  //title
  String title;
  String description;

  //content
  Content content;

  //counts
  int likesCount;
  int viewsCount;
  int commentsCount;

  factory Stories.fromJson(Map<String, dynamic> json) =>
      _$StoriesFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesToJson(this);
}
