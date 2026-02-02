import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';
import '../data/python_data.dart';
import '../core/theme/app_theme.dart';
import '../widgets/performance_chart.dart';
import 'lesson_view_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dummy data for frontend display
  final List<int> _dailyActivity = [5, 8, 3, 7, 2, 6, 4];
  final List<Lesson> _lessons = PythonDummyData.getLessons();

  // Group lessons by stage
  // Group lessons by stage
  Map<LessonStage, List<Lesson>> get _groupedLessons {
    final map = <LessonStage, List<Lesson>>{};
    for (var lesson in _lessons) {
      if (!map.containsKey(lesson.stage)) {
        map[lesson.stage] = [];
      }
      map[lesson.stage]!.add(lesson);
    }
    return map;
  }

  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Light theme
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back, $_userName',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 8),
                      const Text(
                        'Master Python!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Performance Section (Restored)
                  Text(
                    "Weekly Activity",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PerformanceChart(dailyActivity: _dailyActivity),
                  const SizedBox(height: 32),

                  // Python 1-3-7 Sections
                  _buildStageSection(
                    "Day 1: New Learning",
                    LessonStage.day1,
                    Colors.blue,
                  ),
                  _buildStageSection(
                    "Day 3: First Review",
                    LessonStage.day3,
                    Colors.purple,
                  ),
                  _buildStageSection(
                    "Day 7: Strong Roots",
                    LessonStage.day7,
                    Colors.orange,
                  ),
                  _buildStageSection(
                    "Mastered",
                    LessonStage.learned,
                    Colors.green,
                  ),

                  const SizedBox(height: 80), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageSection(String title, LessonStage stage, Color color) {
    final stageLessons = _groupedLessons[stage] ?? [];
    if (stageLessons.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.black87, // Dark text for light theme
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: 16),
        ...stageLessons.map((lesson) => _buildLightLessonCard(lesson, color)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLightLessonCard(Lesson lesson, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LessonViewScreen(lesson: lesson),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    lesson.id.replaceAll('p', ''),
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.content,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.description,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}
