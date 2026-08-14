enum GradeCategory {
  junior, // Nursery to Grade 5
  highSchool, // Grade 6 to Grade 10
  college, // Grade 11, Degree, BCA, BTech
}

class GradeLevelModel {
  final GradeCategory category;
  final String title;
  final String ageRange;
  final String icon;
  final String description;
  final List<String> subjectsPreview;

  const GradeLevelModel({
    required this.category,
    required this.title,
    required this.ageRange,
    required this.icon,
    required this.description,
    required this.subjectsPreview,
  });

  static const List<GradeLevelModel> supportedGrades = [
    GradeLevelModel(
      category: GradeCategory.junior,
      title: 'Junior Academy',
      ageRange: 'Nursery to Grade 5 (Ages 3-10)',
      icon: '🎨',
      description: 'Playful alphabet phonics, number counting, animal match, and shape sorting.',
      subjectsPreview: ['Alphabet & Phonics', 'Numbers & Counting', 'Shapes & Colors', 'Animals & Nature'],
    ),
    GradeLevelModel(
      category: GradeCategory.highSchool,
      title: 'High School Champions',
      ageRange: 'Grade 6 to Grade 10 (Ages 11-16)',
      icon: '🚀',
      description: 'Speed math challenges, science concept scrambles, periodic elements, and history trivia.',
      subjectsPreview: ['Science (Physics/Chem/Bio)', 'Mathematics & Algebra', 'Social Science & History', 'English & Vocab'],
    ),
    GradeLevelModel(
      category: GradeCategory.college,
      title: 'College & University',
      ageRange: 'BCA / BTech / Degree (Ages 17+)',
      icon: '🎓',
      description: 'Data structures, algorithm puzzles, code bug hunting, SQL queries, and syllabus boss battles.',
      subjectsPreview: ['Computer Science & DSA', 'Database Management & SQL', 'Mathematics & Calculus', 'Flutter & App Dev', 'AI & ML'],
    ),
  ];
}
