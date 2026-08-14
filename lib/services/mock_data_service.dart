import '../models/user_model.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/topic_model.dart';
import '../models/study_task_model.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/badge_model.dart';
import '../models/streak_model.dart';
import '../models/analytics_model.dart';
import '../models/notification_model.dart';
import '../models/announcement_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal() {
    _initData();
  }

  late UserModel currentUser;
  late UserModel adminUser;
  List<SubjectModel> subjects = [];
  List<StudyTaskModel> tasks = [];
  List<QuizModel> quizzes = [];
  List<BadgeModel> badges = [];
  late StreakModel userStreak;
  List<AnnouncementModel> announcements = [];
  List<NotificationModel> notifications = [];
  List<LeaderboardEntryModel> leaderboard = [];
  List<UserModel> registeredUsers = [];

  void _initData() {
    final now = DateTime.now();

    // Default Current Student (Mittal Vaja / GLS University BCA Sem V)
    currentUser = UserModel(
      id: 1,
      name: 'Vaja Mital',
      email: 'mital.vaja@glsuniversity.ac.in',
      className: 'BCA Sem V (Div B)',
      role: 'student',
      totalXp: 340,
      currentLevel: 3,
      currentStreak: 7,
      longestStreak: 12,
      badgesEarned: 3,
      createdAt: now.subtract(const Duration(days: 30)),
    );

    // Admin User
    adminUser = UserModel(
      id: 99,
      name: 'Prof. Sharma (Admin)',
      email: 'admin@glsuniversity.ac.in',
      className: 'Faculty of Computer Applications',
      role: 'admin',
      totalXp: 1200,
      currentLevel: 5,
      currentStreak: 20,
      longestStreak: 45,
      badgesEarned: 8,
      createdAt: now.subtract(const Duration(days: 120)),
    );

    registeredUsers = [
      currentUser,
      UserModel(
        id: 2,
        name: 'Kagdi Rehan',
        email: 'rehan.kagdi@glsuniversity.ac.in',
        className: 'BCA Sem V (Div A)',
        role: 'student',
        totalXp: 490,
        currentLevel: 3,
        currentStreak: 5,
        longestStreak: 14,
        badgesEarned: 4,
      ),
      UserModel(
        id: 3,
        name: 'Shaikh Yusrabanu',
        email: 'yusra.shaikh@glsuniversity.ac.in',
        className: 'BCA Sem V (Div B)',
        role: 'student',
        totalXp: 620,
        currentLevel: 4,
        currentStreak: 9,
        longestStreak: 18,
        badgesEarned: 5,
      ),
    ];

    // Subjects with Chapters & Topics
    subjects = [
      SubjectModel(
        id: 1,
        name: 'Mathematics',
        code: 'MAT-501',
        description: 'Linear Algebra, Calculus, and Discrete Structures',
        icon: 'functions',
        colorHex: 0xFF4F46E5,
        chapters: [
          ChapterModel(
            id: 101,
            subjectId: 1,
            name: 'Unit 1: Linear Algebra & Matrices',
            description: 'Matrix transformations, eigenvalues, eigenvectors',
            targetDate: now.add(const Duration(days: 5)),
            topics: [
              TopicModel(
                id: 1001,
                chapterId: 101,
                name: 'Matrix Operations & Inverses',
                description: 'Gaussian elimination and matrix multiplication',
                priority: 'high',
                status: 'completed',
                targetDate: now.subtract(const Duration(days: 4)),
                completedAt: now.subtract(const Duration(days: 3)),
              ),
              TopicModel(
                id: 1002,
                chapterId: 101,
                name: 'Eigenvalues & Eigenvectors',
                description: 'Characteristic equation and diagonalization',
                priority: 'high',
                status: 'completed',
                targetDate: now.subtract(const Duration(days: 1)),
                completedAt: now.subtract(const Duration(days: 1)),
              ),
              TopicModel(
                id: 1003,
                chapterId: 101,
                name: 'Vector Spaces & Subspaces',
                description: 'Basis, dimension, linear independence',
                priority: 'medium',
                status: 'pending',
                targetDate: now.add(const Duration(days: 3)),
              ),
            ],
          ),
          ChapterModel(
            id: 102,
            subjectId: 1,
            name: 'Unit 2: Differential Calculus',
            description: 'Partial derivatives, maxima & minima',
            targetDate: now.add(const Duration(days: 18)),
            topics: [
              TopicModel(
                id: 1004,
                chapterId: 102,
                name: 'Limits & Continuity in Multivariables',
                description: 'Epsilon-delta definitions and squeeze theorem',
                priority: 'medium',
                status: 'completed',
                targetDate: now.subtract(const Duration(days: 2)),
                completedAt: now.subtract(const Duration(days: 2)),
              ),
              TopicModel(
                id: 1005,
                chapterId: 102,
                name: 'Lagrange Multipliers & Optimization',
                description: 'Constrained optimization problems',
                priority: 'high',
                status: 'pending',
                targetDate: now.add(const Duration(days: 10)),
              ),
            ],
          ),
        ],
      ),
      SubjectModel(
        id: 2,
        name: 'Computer Science',
        code: 'CSC-502',
        description: 'Data Structures, Graph Algorithms & Complexity',
        icon: 'memory',
        colorHex: 0xFF0EA5E9,
        chapters: [
          ChapterModel(
            id: 201,
            subjectId: 2,
            name: 'Unit 1: Trees & Balanced BSTs',
            description: 'AVL Trees, Red-Black Trees, and Heaps',
            targetDate: now.add(const Duration(days: 6)),
            topics: [
              TopicModel(
                id: 2001,
                chapterId: 201,
                name: 'Binary Search Tree Traversals',
                description: 'Inorder, Preorder, Postorder & Level Order',
                priority: 'high',
                status: 'completed',
                targetDate: now.subtract(const Duration(days: 5)),
                completedAt: now.subtract(const Duration(days: 4)),
              ),
              TopicModel(
                id: 2002,
                chapterId: 201,
                name: 'AVL Tree Rotations',
                description: 'LL, RR, LR, RL tree rebalancing algorithms',
                priority: 'high',
                status: 'completed',
                targetDate: now.subtract(const Duration(days: 2)),
                completedAt: now.subtract(const Duration(days: 1)),
              ),
              TopicModel(
                id: 2003,
                chapterId: 201,
                name: 'Min/Max Binary Heaps',
                description: 'Heapify, Priority Queue operations and HeapSort',
                priority: 'medium',
                status: 'pending',
                targetDate: now.add(const Duration(days: 2)),
              ),
            ],
          ),
          ChapterModel(
            id: 202,
            subjectId: 2,
            name: 'Unit 2: Graph Theory & Algorithms',
            description: 'BFS, DFS, Dijkstra, Kruskal, Prim',
            targetDate: now.add(const Duration(days: 20)),
            topics: [
              TopicModel(
                id: 2004,
                chapterId: 202,
                name: 'Graph Representation & BFS/DFS',
                description: 'Adjacency list vs matrix and connected components',
                priority: 'medium',
                status: 'pending',
                targetDate: now.add(const Duration(days: 8)),
              ),
              TopicModel(
                id: 2005,
                chapterId: 202,
                name: 'Shortest Path - Dijkstra Algorithm',
                description: 'Greedy shortest path with adjacency list',
                priority: 'high',
                status: 'pending',
                targetDate: now.add(const Duration(days: 14)),
              ),
            ],
          ),
        ],
      ),
      SubjectModel(
        id: 3,
        name: 'Database Management',
        code: 'DBMS-503',
        description: 'Relational Model, Normalization, SQL & Indexing',
        icon: 'storage',
        colorHex: 0xFF10B981,
        chapters: [
          ChapterModel(
            id: 301,
            subjectId: 3,
            name: 'Unit 1: Relational Schema & SQL',
            description: 'DDL, DML, Joins, Subqueries and Views',
            targetDate: now.add(const Duration(days: 4)),
            topics: [
              TopicModel(
                id: 3001,
                chapterId: 301,
                name: 'Advanced SQL Joins & Subqueries',
                description: 'INNER, LEFT, RIGHT, FULL OUTER joins and CTEs',
                priority: 'high',
                status: 'completed',
                targetDate: now.subtract(const Duration(days: 3)),
                completedAt: now.subtract(const Duration(days: 2)),
              ),
              TopicModel(
                id: 3002,
                chapterId: 301,
                name: 'Database Normalization (1NF to BCNF)',
                description: 'Functional dependencies, 2NF, 3NF and Boyce-Codd',
                priority: 'high',
                status: 'pending',
                targetDate: now.add(const Duration(days: 1)),
              ),
            ],
          ),
          ChapterModel(
            id: 302,
            subjectId: 3,
            name: 'Unit 2: Transactions & Concurrency',
            description: 'ACID properties, Locks, Deadlocks and 2PL',
            targetDate: now.add(const Duration(days: 22)),
            topics: [
              TopicModel(
                id: 3003,
                chapterId: 302,
                name: 'ACID Properties & Serializability',
                description: 'Conflict serializability and precedence graphs',
                priority: 'medium',
                status: 'pending',
                targetDate: now.add(const Duration(days: 12)),
              ),
            ],
          ),
        ],
      ),
      SubjectModel(
        id: 4,
        name: 'Web & Mobile App Dev',
        code: 'MAD-504',
        description: 'Flutter, Dart, State Management & REST APIs',
        icon: 'phone_android',
        colorHex: 0xFF8B5CF6,
        chapters: [
          ChapterModel(
            id: 401,
            subjectId: 4,
            name: 'Unit 1: Flutter Architecture & Widgets',
            description: 'Stateless vs Stateful, Layouts & Themes',
            targetDate: now.add(const Duration(days: 7)),
            topics: [
              TopicModel(
                id: 4001,
                chapterId: 401,
                name: 'Widget Lifecycle & BuildContext',
                description: 'initState, didUpdateWidget, dispose methods',
                priority: 'high',
                status: 'completed',
                targetDate: now.subtract(const Duration(days: 1)),
                completedAt: now.subtract(const Duration(days: 1)),
              ),
              TopicModel(
                id: 4002,
                chapterId: 401,
                name: 'Provider State Management',
                description: 'ChangeNotifier, ChangeNotifierProvider, Consumer',
                priority: 'high',
                status: 'pending',
                targetDate: now.add(const Duration(days: 2)),
              ),
            ],
          ),
        ],
      ),
      SubjectModel(
        id: 5,
        name: 'Artificial Intelligence',
        code: 'AI-505',
        description: 'Search algorithms, Knowledge Representation, ML',
        icon: 'psychology',
        colorHex: 0xFFF59E0B,
        chapters: [
          ChapterModel(
            id: 501,
            subjectId: 5,
            name: 'Unit 1: Search & Heuristics',
            description: 'A* Search, Minimax, Alpha-Beta Pruning',
            targetDate: now.add(const Duration(days: 15)),
            topics: [
              TopicModel(
                id: 5001,
                chapterId: 501,
                name: 'A* Search & Admissibility',
                description: 'Evaluation function f(n) = g(n) + h(n)',
                priority: 'medium',
                status: 'pending',
                targetDate: now.add(const Duration(days: 9)),
              ),
            ],
          ),
        ],
      ),
    ];

    // Today's Study Tasks
    tasks = [
      StudyTaskModel(
        id: 1,
        userId: 1,
        topicId: 3002,
        subjectName: 'Database Management',
        topicName: 'Database Normalization (1NF to BCNF)',
        date: DateTime(now.year, now.month, now.day),
        startTime: '10:00 AM',
        durationMinutes: 45,
        priority: 'high',
        status: 'pending',
      ),
      StudyTaskModel(
        id: 2,
        userId: 1,
        topicId: 2003,
        subjectName: 'Computer Science',
        topicName: 'Min/Max Binary Heaps',
        date: DateTime(now.year, now.month, now.day),
        startTime: '02:30 PM',
        durationMinutes: 60,
        priority: 'medium',
        status: 'pending',
      ),
      StudyTaskModel(
        id: 3,
        userId: 1,
        topicId: 4002,
        subjectName: 'Web & Mobile App Dev',
        topicName: 'Provider State Management',
        date: DateTime(now.year, now.month, now.day),
        startTime: '05:00 PM',
        durationMinutes: 45,
        priority: 'high',
        status: 'pending',
      ),
      StudyTaskModel(
        id: 4,
        userId: 1,
        topicId: 1002,
        subjectName: 'Mathematics',
        topicName: 'Eigenvalues & Eigenvectors',
        date: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)),
        startTime: '11:00 AM',
        durationMinutes: 50,
        priority: 'high',
        status: 'completed',
        completedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    // Quizzes with real MCQ questions
    quizzes = [
      QuizModel(
        id: 1,
        chapterId: 101,
        subjectName: 'Mathematics',
        chapterName: 'Unit 1: Linear Algebra & Matrices',
        title: 'Matrix & Eigenvalues Mastery Quiz',
        xpReward: 20,
        questions: [
          QuestionModel(
            id: 1,
            quizId: 1,
            questionText: 'What is the determinant of an identity matrix I of size 3x3?',
            options: ['0', '1', '3', 'Undefined'],
            correctOptionIndex: 1,
            explanation: 'The determinant of any identity matrix of any size is always equal to 1.',
          ),
          QuestionModel(
            id: 2,
            quizId: 1,
            questionText: 'If λ is an eigenvalue of matrix A, then (A - λI) must be:',
            options: ['Orthogonal', 'Invertible', 'Singular (Det = 0)', 'Symmetric'],
            correctOptionIndex: 2,
            explanation: 'By the characteristic equation det(A - λI) = 0, matrix (A - λI) is singular.',
          ),
          QuestionModel(
            id: 3,
            quizId: 1,
            questionText: 'The trace of a square matrix equals the sum of its:',
            options: ['Diagonal elements & Eigenvalues', 'Row sums', 'Determinants', 'Singular values only'],
            correctOptionIndex: 0,
            explanation: 'The trace of a matrix is the sum of diagonal entries, which also equals the sum of its eigenvalues.',
          ),
        ],
        lastAttempt: QuizAttemptModel(
          id: 101,
          quizId: 1,
          score: 3,
          totalQuestions: 3,
          percentage: 100.0,
          xpEarned: 25,
          attemptedAt: now.subtract(const Duration(days: 2)),
        ),
      ),
      QuizModel(
        id: 2,
        chapterId: 201,
        subjectName: 'Computer Science',
        chapterName: 'Unit 1: Trees & Balanced BSTs',
        title: 'AVL Trees & BST Operations Quiz',
        xpReward: 20,
        questions: [
          QuestionModel(
            id: 4,
            quizId: 2,
            questionText: 'What is the balance factor allowed for any node in an AVL tree?',
            options: ['-1, 0, +1', 'Only 0', '-2, 0, +2', 'Any positive integer'],
            correctOptionIndex: 0,
            explanation: 'An AVL tree requires the height difference (left - right) to be strictly in {-1, 0, 1}.',
          ),
          QuestionModel(
            id: 5,
            quizId: 2,
            questionText: 'What is the worst-case time complexity of searching in an AVL tree with n nodes?',
            options: ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
            correctOptionIndex: 1,
            explanation: 'Because AVL trees are strictly balanced, height is logarithmic: O(log n).',
          ),
          QuestionModel(
            id: 6,
            quizId: 2,
            questionText: 'Which traversal of a Binary Search Tree produces sorted values in ascending order?',
            options: ['Preorder', 'Inorder', 'Postorder', 'Level order'],
            correctOptionIndex: 1,
            explanation: 'Inorder traversal visits Left Subtree -> Root -> Right Subtree, resulting in sorted output.',
          ),
        ],
      ),
      QuizModel(
        id: 3,
        chapterId: 301,
        subjectName: 'Database Management',
        chapterName: 'Unit 1: Relational Schema & SQL',
        title: 'SQL Normalization & Joins Challenge',
        xpReward: 25,
        questions: [
          QuestionModel(
            id: 7,
            quizId: 3,
            questionText: 'A relation is in 2NF if it is in 1NF and contains no:',
            options: ['Transitive dependencies', 'Partial functional dependencies', 'Multi-valued attributes', 'Foreign keys'],
            correctOptionIndex: 1,
            explanation: '2NF eliminates partial functional dependency on a composite primary key.',
          ),
          QuestionModel(
            id: 8,
            quizId: 3,
            questionText: 'Which SQL join returns all rows from the left table and matched rows from the right table?',
            options: ['FULL JOIN', 'INNER JOIN', 'LEFT OUTER JOIN', 'CROSS JOIN'],
            correctOptionIndex: 2,
            explanation: 'LEFT JOIN returns all records from the left table, with NULLs for unmatched right rows.',
          ),
        ],
      ),
    ];

    // Badges
    badges = [
      BadgeModel(
        id: 1,
        code: 'first_step',
        name: 'First Step',
        description: 'Complete your first syllabus topic',
        iconEmoji: '🚀',
        category: 'topic',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 20)),
        requiredCount: 1,
        currentProgress: 1,
      ),
      BadgeModel(
        id: 2,
        code: 'streak_3',
        name: '3-Day Streak',
        description: 'Study for 3 consecutive days',
        iconEmoji: '⚡',
        category: 'streak',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 5)),
        requiredCount: 3,
        currentProgress: 3,
      ),
      BadgeModel(
        id: 3,
        code: 'streak_7',
        name: '7-Day Streak',
        description: 'Maintain a 7-day continuous study streak',
        iconEmoji: '🔥',
        category: 'streak',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(hours: 4)),
        requiredCount: 7,
        currentProgress: 7,
      ),
      BadgeModel(
        id: 4,
        code: 'perfect_score',
        name: 'Perfect Score',
        description: 'Score 100% on any chapter quiz',
        iconEmoji: '🎯',
        category: 'quiz',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 2)),
        requiredCount: 1,
        currentProgress: 1,
      ),
      BadgeModel(
        id: 5,
        code: 'math_master',
        name: 'Math Master',
        description: 'Complete all topics in Mathematics',
        iconEmoji: '📐',
        category: 'topic',
        isUnlocked: false,
        requiredCount: 5,
        currentProgress: 3,
      ),
      BadgeModel(
        id: 6,
        code: 'quiz_champion',
        name: 'Quiz Champion',
        description: 'Complete 10 quizzes successfully',
        iconEmoji: '🏆',
        category: 'quiz',
        isUnlocked: false,
        requiredCount: 10,
        currentProgress: 2,
      ),
      BadgeModel(
        id: 7,
        code: 'syllabus_crusher',
        name: 'Syllabus Crusher',
        description: 'Complete 25 total study topics',
        iconEmoji: '💥',
        category: 'topic',
        isUnlocked: false,
        requiredCount: 25,
        currentProgress: 6,
      ),
      BadgeModel(
        id: 8,
        code: 'scholar_tier',
        name: 'Scholar',
        description: 'Reach Level 5 (Scholar) with 900+ XP',
        iconEmoji: '🎓',
        category: 'level',
        isUnlocked: false,
        requiredCount: 900,
        currentProgress: 340,
      ),
    ];

    // User Streak
    userStreak = StreakModel(
      userId: 1,
      currentStreak: 7,
      longestStreak: 12,
      lastActivityDate: now,
      activeDates: List.generate(7, (i) => now.subtract(Duration(days: i))),
    );

    // Announcements
    announcements = [
      AnnouncementModel(
        id: 1,
        authorName: 'GLS University Exam Cell',
        title: 'BCA Semester V Mid-Term Syllabus Scope',
        content: 'Dear Students, Mid-Term assessments begin next month. Please complete Units 1 & 2 for all core subjects.',
        tag: 'Academic Notice',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      AnnouncementModel(
        id: 2,
        authorName: 'Faculty of Computer Applications',
        title: 'Flutter Cross-Platform Project Submissions',
        content: 'Ensure all milestone prototypes for Gamified Syllabus Tracker are updated with Provider state management.',
        tag: 'Project Guideline',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    // Notifications
    notifications = [
      NotificationModel(
        id: 1,
        userId: 1,
        title: "You're on fire! 🔥",
        message: 'You have achieved a 7-day study streak! +15 XP bonus awarded.',
        type: 'streak',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      NotificationModel(
        id: 2,
        userId: 1,
        title: 'Upcoming Deadline Alert ⏰',
        message: 'Database Normalization topic target date is tomorrow. Complete it to stay on track!',
        type: 'reminder',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      NotificationModel(
        id: 3,
        userId: 1,
        title: 'Perfect Score Badge Unlocked! 🎯',
        message: 'Congratulations! You scored 100% on the Linear Algebra Quiz.',
        type: 'system',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    // Leaderboard
    leaderboard = [
      LeaderboardEntryModel(
        rank: 1,
        userId: 3,
        name: 'Shaikh Yusrabanu',
        className: 'BCA Sem V (Div B)',
        totalXp: 620,
        level: 4,
        badgesCount: 5,
      ),
      LeaderboardEntryModel(
        rank: 2,
        userId: 2,
        name: 'Kagdi Rehan',
        className: 'BCA Sem V (Div A)',
        totalXp: 490,
        level: 3,
        badgesCount: 4,
      ),
      LeaderboardEntryModel(
        rank: 3,
        userId: 1,
        name: 'Vaja Mital (You)',
        className: 'BCA Sem V (Div B)',
        totalXp: 340,
        level: 3,
        badgesCount: 3,
      ),
      LeaderboardEntryModel(
        rank: 4,
        userId: 4,
        name: 'Patel Aarav',
        className: 'BCA Sem V (Div A)',
        totalXp: 280,
        level: 3,
        badgesCount: 2,
      ),
      LeaderboardEntryModel(
        rank: 5,
        userId: 5,
        name: 'Shah Diya',
        className: 'BCA Sem V (Div B)',
        totalXp: 190,
        level: 2,
        badgesCount: 1,
      ),
    ];
  }
}
