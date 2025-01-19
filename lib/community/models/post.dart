import 'package:hive/hive.dart';

part 'post.g.dart';

@HiveType(typeId: 1)
class Post extends HiveObject {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final String authorName;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final DateTime dateCreated;

  Post({
    required this.content,
    required this.authorName,
    required this.location,
    DateTime? dateCreated,
  }) : dateCreated = dateCreated ?? DateTime.now();
}
