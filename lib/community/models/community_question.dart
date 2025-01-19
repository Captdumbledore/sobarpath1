import 'package:hive/hive.dart';

part 'community_question.g.dart';

@HiveType(typeId: 0)
class CommunityQuestion extends HiveObject {
  @HiveField(0)
  String question;

  @HiveField(1)
  String answer;

  @HiveField(2)
  DateTime dateCreated;

  @HiveField(3)
  String category;

  CommunityQuestion({
    required this.question,
    this.answer = '',
    required this.category,
    DateTime? dateCreated,
  }) : dateCreated = dateCreated ?? DateTime.now();
}
