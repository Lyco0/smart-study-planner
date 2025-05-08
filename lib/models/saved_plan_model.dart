import 'package:hive/hive.dart';
part 'saved_plan_model.g.dart';

@HiveType(typeId: 0)
class SavedPlan extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String subject;

  @HiveField(2)
  List<String> topics;

  @HiveField(3)
  String planMarkdown;

  @HiveField(4)
  String timeRange;

  SavedPlan({
    required this.name,
    required this.subject,
    required this.topics,
    required this.planMarkdown,
    required this.timeRange,
  });
}
