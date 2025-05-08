import 'package:hive/hive.dart';
import '../models/saved_plan_model.dart';

class SavedPlanRepository {
  static const String boxName = 'savedPlans';

  static Future<void> savePlan(SavedPlan plan) async {
    final box = await Hive.openBox<SavedPlan>(boxName);
    await box.put(plan.name, plan);
  }

  static Future<void> renamePlan(String oldName, String newName) async {
    final box = await Hive.openBox<SavedPlan>(boxName);
    final plan = box.get(oldName);
    if (plan != null) {
      await box.delete(oldName);
      plan.name = newName;
      await box.put(newName, plan);
    }
  }

  static Future<List<SavedPlan>> getAllPlans() async {
    final box = await Hive.openBox<SavedPlan>(boxName);
    return box.values.toList();
  }

  static Future<SavedPlan?> getPlan(String name) async {
    final box = await Hive.openBox<SavedPlan>(boxName);
    return box.get(name);
  }

  static Future<void> deletePlan(String name) async {
    final box = await Hive.openBox<SavedPlan>(boxName);
    await box.delete(name);
  }
}
