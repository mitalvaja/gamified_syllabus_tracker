-- =============================================================================
-- GAMIFIED SYLLABUS TRACKER - SAMPLE DATA SEEDER (MySQL)
-- =============================================================================

USE `gamified_syllabus_db`;

-- Users
INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `class`, `role`, `total_xp`, `current_level`) VALUES
(1, 'Vaja Mital', 'mital.vaja@glsuniversity.ac.in', '$2a$10$e7Vj/1Jb2lB..458aMockHash', 'BCA Sem V (Div B)', 'student', 340, 3),
(2, 'Kagdi Rehan', 'rehan.kagdi@glsuniversity.ac.in', '$2a$10$e7Vj/1Jb2lB..458aMockHash', 'BCA Sem V (Div A)', 'student', 490, 3),
(3, 'Shaikh Yusrabanu', 'yusra.shaikh@glsuniversity.ac.in', '$2a$10$e7Vj/1Jb2lB..458aMockHash', 'BCA Sem V (Div B)', 'student', 620, 4),
(99, 'Prof. Sharma (Admin)', 'admin@glsuniversity.ac.in', '$2a$10$e7Vj/1Jb2lB..458aMockHash', 'Faculty of Computer Applications', 'admin', 1200, 5)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Streaks
INSERT INTO `streaks` (`user_id`, `current_streak`, `longest_streak`, `last_activity_date`) VALUES
(1, 7, 12, CURDATE())
ON DUPLICATE KEY UPDATE `current_streak`=VALUES(`current_streak`);

-- Badges Master
INSERT INTO `badges` (`id`, `code`, `name`, `description`, `icon`, `category`, `required_count`, `condition_type`) VALUES
(1, 'first_step', 'First Step', 'Complete your first syllabus topic', '🚀', 'topic', 1, 'topic_complete_1'),
(2, 'streak_3', '3-Day Streak', 'Study for 3 consecutive days', '⚡', 'streak', 3, 'streak_3'),
(3, 'streak_7', '7-Day Streak', 'Maintain a 7-day continuous study streak', '🔥', 'streak', 7, 'streak_7'),
(4, 'perfect_score', 'Perfect Score', 'Score 100% on any chapter quiz', '🎯', 'quiz', 1, 'quiz_perfect_1'),
(5, 'math_master', 'Math Master', 'Complete all topics in Mathematics', '📐', 'topic', 5, 'subject_complete_math'),
(6, 'quiz_champion', 'Quiz Champion', 'Complete 10 quizzes successfully', '🏆', 'quiz', 10, 'quiz_complete_10'),
(7, 'syllabus_crusher', 'Syllabus Crusher', 'Complete 25 total study topics', '💥', 'topic', 25, 'topics_complete_25'),
(8, 'scholar_tier', 'Scholar', 'Reach Level 5 (Scholar) with 900+ XP', '🎓', 'level', 900, 'xp_900')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- User Badges Unlocked for Mital
INSERT INTO `user_badges` (`user_id`, `badge_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4)
ON DUPLICATE KEY UPDATE `badge_id`=VALUES(`badge_id`);

-- Subjects
INSERT INTO `subjects` (`id`, `name`, `code`, `description`, `color_hex`, `user_id`) VALUES
(1, 'Mathematics', 'MAT-501', 'Linear Algebra, Calculus, and Discrete Structures', 5195493, 1),
(2, 'Computer Science', 'CSC-502', 'Data Structures, Graph Algorithms & Complexity', 960009, 1),
(3, 'Database Management', 'DBMS-503', 'Relational Model, Normalization, SQL & Indexing', 1096065, 1),
(4, 'Web & Mobile App Dev', 'MAD-504', 'Flutter, Dart, State Management & REST APIs', 9133302, 1),
(5, 'Artificial Intelligence', 'AI-505', 'Search algorithms, Knowledge Representation, ML', 16101131, 1)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Chapters
INSERT INTO `chapters` (`id`, `subject_id`, `name`, `description`, `target_date`) VALUES
(101, 1, 'Unit 1: Linear Algebra & Matrices', 'Matrix transformations, eigenvalues, eigenvectors', DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
(102, 1, 'Unit 2: Differential Calculus', 'Partial derivatives, maxima & minima', DATE_ADD(CURDATE(), INTERVAL 18 DAY)),
(201, 2, 'Unit 1: Trees & Balanced BSTs', 'AVL Trees, Red-Black Trees, and Heaps', DATE_ADD(CURDATE(), INTERVAL 6 DAY)),
(301, 3, 'Unit 1: Relational Schema & SQL', 'DDL, DML, Joins, Subqueries and Views', DATE_ADD(CURDATE(), INTERVAL 4 DAY)),
(401, 4, 'Unit 1: Flutter Architecture & Widgets', 'Stateless vs Stateful, Layouts & Themes', DATE_ADD(CURDATE(), INTERVAL 7 DAY))
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Topics
INSERT INTO `topics` (`id`, `chapter_id`, `name`, `description`, `priority`, `status`, `target_date`, `completed_at`) VALUES
(1001, 101, 'Matrix Operations & Inverses', 'Gaussian elimination and matrix multiplication', 'high', 'completed', DATE_SUB(CURDATE(), INTERVAL 4 DAY), NOW()),
(1002, 101, 'Eigenvalues & Eigenvectors', 'Characteristic equation and diagonalization', 'high', 'completed', DATE_SUB(CURDATE(), INTERVAL 1 DAY), NOW()),
(1003, 101, 'Vector Spaces & Subspaces', 'Basis, dimension, linear independence', 'medium', 'pending', DATE_ADD(CURDATE(), INTERVAL 3 DAY), NULL),
(2001, 201, 'Binary Search Tree Traversals', 'Inorder, Preorder, Postorder & Level Order', 'high', 'completed', DATE_SUB(CURDATE(), INTERVAL 3 DAY), NOW()),
(2002, 201, 'AVL Tree Rotations', 'LL, RR, LR, RL tree rebalancing algorithms', 'high', 'completed', DATE_SUB(CURDATE(), INTERVAL 1 DAY), NOW()),
(2003, 201, 'Min/Max Binary Heaps', 'Heapify, Priority Queue operations and HeapSort', 'medium', 'pending', DATE_ADD(CURDATE(), INTERVAL 2 DAY), NULL),
(3001, 301, 'Advanced SQL Joins & Subqueries', 'INNER, LEFT, RIGHT, FULL OUTER joins and CTEs', 'high', 'completed', DATE_SUB(CURDATE(), INTERVAL 2 DAY), NOW()),
(3002, 301, 'Database Normalization (1NF to BCNF)', 'Functional dependencies, 2NF, 3NF and Boyce-Codd', 'high', 'pending', DATE_ADD(CURDATE(), INTERVAL 1 DAY), NULL),
(4001, 401, 'Widget Lifecycle & BuildContext', 'initState, didUpdateWidget, dispose methods', 'high', 'completed', DATE_SUB(CURDATE(), INTERVAL 1 DAY), NOW()),
(4002, 401, 'Provider State Management', 'ChangeNotifier, ChangeNotifierProvider, Consumer', 'high', 'pending', DATE_ADD(CURDATE(), INTERVAL 2 DAY), NULL)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Announcements
INSERT INTO `announcements` (`id`, `admin_id`, `title`, `content`, `tag`, `created_at`) VALUES
(1, 99, 'BCA Semester V Mid-Term Syllabus Scope', 'Dear Students, Mid-Term assessments begin next month. Please complete Units 1 & 2 for all core subjects.', 'Academic Notice', NOW()),
(2, 99, 'Flutter Cross-Platform Project Submissions', 'Ensure all milestone prototypes for Gamified Syllabus Tracker are updated with Provider state management.', 'Project Guideline', NOW())
ON DUPLICATE KEY UPDATE `title`=VALUES(`title`);
