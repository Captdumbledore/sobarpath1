import 'package:hive/hive.dart';

part 'job.g.dart';

@HiveType(typeId: 4)
class Job extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String company;

  @HiveField(3)
  final String salary;

  @HiveField(4)
  final List<String> type;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.salary,
    required this.type,
  });
}
