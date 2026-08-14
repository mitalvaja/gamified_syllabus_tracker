import 'package:flutter_test/flutter_test.dart';
import 'package:gamified_syllabus_tracker/core/utils/level_calculator.dart';
import 'package:gamified_syllabus_tracker/core/utils/date_formatter.dart';
import 'package:gamified_syllabus_tracker/models/user_model.dart';
import 'package:gamified_syllabus_tracker/models/subject_model.dart';
import 'package:gamified_syllabus_tracker/models/chapter_model.dart';
import 'package:gamified_syllabus_tracker/models/topic_model.dart';
import 'package:gamified_syllabus_tracker/models/grade_level_model.dart';
import 'package:gamified_syllabus_tracker/providers/game_provider.dart';

void main() {
  group('Gamification & Level Progression Tests', () {
    test('Level 1 Beginner for 0 to 99 XP', () {
      final info0 = LevelCalculator.calculate(0);
      expect(info0.level, 1);
      expect(info0.title, 'Beginner');

      final info50 = LevelCalculator.calculate(50);
      expect(info50.level, 1);
      expect(info50.progress, 0.5);
    });

    test('Level 3 Explorer for 340 XP', () {
      final info = LevelCalculator.calculate(340);
      expect(info.level, 3);
      expect(info.title, 'Explorer');
      expect(info.xpToNextLevel, 160); // 500 - 340
    });

    test('Level 6 Pro for 1500+ XP', () {
      final info = LevelCalculator.calculate(2000);
      expect(info.level, 6);
      expect(info.title, 'Pro');
      expect(info.progress, 1.0);
    });
  });

  group('Date & Urgency Formatter Tests', () {
    test('Detect overdue dates correctly', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));
      expect(DateFormatter.isOverdue(pastDate, isCompleted: false), isTrue);
      expect(DateFormatter.isOverdue(pastDate, isCompleted: true), isFalse);
    });

    test('Detect approaching dates correctly', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(DateFormatter.isApproaching(tomorrow, daysThreshold: 3), isTrue);
    });
  });

  group('Syllabus Model Hierarchy Tests', () {
    test('Subject progress calculation', () {
      final topic1 = TopicModel(id: 1, chapterId: 101, name: 'Topic 1', status: 'completed');
      final topic2 = TopicModel(id: 2, chapterId: 101, name: 'Topic 2', status: 'pending');
      final chapter = ChapterModel(id: 101, subjectId: 1, name: 'Chapter 1', topics: [topic1, topic2]);
      final subject = SubjectModel(id: 1, name: 'Math', chapters: [chapter]);

      expect(subject.totalTopics, 2);
      expect(subject.completedTopics, 1);
      expect(subject.progressPercentage, 0.5);
      expect(subject.progressPercentInt, 50);
    });
  });

  group('Multi-Grade Educational Games Tests', () {
    test('Supported grades tier definition (Junior to College)', () {
      expect(GradeLevelModel.supportedGrades.length, 3);
      expect(GradeLevelModel.supportedGrades[0].category, GradeCategory.junior);
      expect(GradeLevelModel.supportedGrades[1].category, GradeCategory.highSchool);
      expect(GradeLevelModel.supportedGrades[2].category, GradeCategory.college);
    });

    test('GameProvider grade switching and star tracking', () async {
      final provider = GameProvider();
      expect(provider.activeGrade, GradeCategory.college);

      provider.setGradeCategory(GradeCategory.junior);
      expect(provider.activeGrade, GradeCategory.junior);

      await provider.recordGameResult(
        gameKey: 'memory_match',
        score: 350,
        stars: 3,
        xpEarned: 30,
      );

      expect(provider.highScores['memory_match'], 350);
      expect(provider.starsEarned['memory_match'], 3);
      expect(provider.totalStars, greaterThanOrEqualTo(3));
    });
  });
}
