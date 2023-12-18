import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.id = '',
    this.displayName = '',
    this.userName = '',
    this.listOfLikers = const [],
  });

  String displayName;
  String userName;
  String id;

  List<String> listOfLikers;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
