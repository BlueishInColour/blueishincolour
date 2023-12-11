import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'stories.g.dart';

@JsonSerializable()
class Stories {
  Stories(
      {
      //
      this.creator = '',
      this.userId = 0,
      //
      this.title = '',
      this.body = '',
      required this.createdAt,
      //
//counts
      this.reactions = 0,
      this.tags = const []

      //
      });
  //id
  int userId;
  //creator
  String creator;

  //title
  String title;
  DateTime createdAt;
  //content
  List<String> tags;
  int reactions;
  String body;

  factory Stories.fromJson(Map<String, dynamic> json) =>
      _$StoriesFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesToJson(this);
}
