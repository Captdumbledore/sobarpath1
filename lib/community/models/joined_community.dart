import 'package:hive/hive.dart';

part 'joined_community.g.dart';

@HiveType(typeId: 2)
class JoinedCommunity extends HiveObject {
  @HiveField(0)
  final String communityName;

  @HiveField(1)
  final DateTime joinedDate;

  JoinedCommunity({
    required this.communityName,
    DateTime? joinedDate,
  }) : joinedDate = joinedDate ?? DateTime.now();
}
