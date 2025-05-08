import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/saved_plan_repository.dart';
import '../screens/saved_plan_screen.dart';

class PlanListDrawer extends StatefulWidget {
  const PlanListDrawer({super.key});

  @override
  State<PlanListDrawer> createState() => _PlanListDrawerState();
}

class _PlanListDrawerState extends State<PlanListDrawer> {
  final storage = const FlutterSecureStorage();
  String username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final storedUsername = await storage.read(key: 'username');
    if (storedUsername != null) {
      setState(() {
        username = storedUsername;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFE0D6FE), // Background color
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 20), // Increased top padding
              decoration: const BoxDecoration(
                color: Color(0xFFE0D6FE),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text(
                      'Saved Study Plans',
                      style: const TextStyle(
                        fontSize: 24, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Consistent text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: SavedPlanRepository.getAllPlans(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple, // Consistent color
                      ),
                    );
                  }
                  final plans = snapshot.data!;
                  if (plans.isEmpty) {
                    return const Center(
                      child: Text(
                        'No saved plans.',
                        style: TextStyle(
                          color: Colors.grey, // Consistent color
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  return ListView.separated( // Use ListView.separated for dividers
                    itemCount: plans.length,
                    separatorBuilder: (context, index) =>
                    const Divider(color: Colors.grey), // Divider color
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return ListTile(
                        title: Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 18, // Increased font size
                            color: Colors.black, // Consistent text color
                          ),
                        ),
                        subtitle: Text(
                          plan.subject,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey, // Consistent color
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SavedPlanScreen(plan: plan)),
                          );
                        },
                        onLongPress: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Plan'),
                              content: Text('Are you sure you want to delete "${plan.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                                  child: const Text('Delete',
                                    style: TextStyle(color: Colors.white),),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await plan.delete(); // Uses HiveObject.delete()
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🗑️ Plan deleted')),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(color: Colors.grey), // Divider color
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Logged in as: $username',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey, // Consistent color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

