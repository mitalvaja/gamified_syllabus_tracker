import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/grade_level_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/gamification_provider.dart';

class CodeBugItem {
  final String language;
  final String title;
  final String buggyCode;
  final List<String> options;
  final int correctOptionIndex;
  final String fixExplanation;

  const CodeBugItem({
    required this.language,
    required this.title,
    required this.buggyCode,
    required this.options,
    required this.correctOptionIndex,
    required this.fixExplanation,
  });
}

class CodeBugHunterGameScreen extends StatefulWidget {
  final GradeCategory gradeCategory;

  const CodeBugHunterGameScreen({super.key, required this.gradeCategory});

  @override
  State<CodeBugHunterGameScreen> createState() => _CodeBugHunterGameScreenState();
}

class _CodeBugHunterGameScreenState extends State<CodeBugHunterGameScreen> {
  int _score = 0;
  int _currentIdx = 0;
  int _secondsLeft = 30;
  Timer? _timer;
  List<CodeBugItem> _bugs = [];

  @override
  void initState() {
    super.initState();
    _loadBugs();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadBugs() {
    _bugs = [
      const CodeBugItem(
        language: 'Dart / Flutter',
        title: 'Missing Keyword in Widget State',
        buggyCode: 'class MyWidget extends StatelessWidget {\n  Widget build(BuildContext context) {\n    return Text("Hello");\n  }\n}',
        options: ['Add @override before build()', 'Change to StatefulWidget', 'Add semicolon after return', 'Rename BuildContext'],
        correctOptionIndex: 0,
        fixExplanation: 'The build method overrides the superclass method, so @override is required.',
      ),
      const CodeBugItem(
        language: 'SQL',
        title: 'Incorrect Filter Clause',
        buggyCode: 'SELECT name, marks\nFROM students\nHAVING marks > 75;',
        options: ['Change HAVING to WHERE', 'Change SELECT to GET', 'Add GROUP BY name', 'Replace FROM with IN'],
        correctOptionIndex: 0,
        fixExplanation: 'WHERE is used for row-level filtering, whereas HAVING is used with GROUP BY aggregations.',
      ),
      const CodeBugItem(
        language: 'DSA / Dart',
        title: 'Off-by-One Array Bound Exception',
        buggyCode: 'List<int> nums = [10, 20, 30];\nfor (int i = 0; i <= nums.length; i++) {\n  print(nums[i]);\n}',
        options: ['Change i <= nums.length to i < nums.length', 'Initialize i = 1', 'Change print to log', 'Make nums const'],
        correctOptionIndex: 0,
        fixExplanation: 'Array indices range from 0 to length - 1. Using <= causes RangeError (Index out of bounds).',
      ),
      const CodeBugItem(
        language: 'Python',
        title: 'Indentation Error in Loop',
        buggyCode: 'def calculate_sum(n):\nsum = 0\nfor i in range(n):\nsum += i\nreturn sum',
        options: ['Indent lines inside function & loop body', 'Change sum to total', 'Replace range with list', 'Add semicolon'],
        correctOptionIndex: 0,
        fixExplanation: 'Python requires 4-space indentation for code blocks inside functions and loops.',
      ),
    ];

    _bugs.shuffle();
    _currentIdx = 0;
    _score = 0;
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        _onTimeOut();
      }
    });
  }

  void _onAnswerChosen(int idx) {
    _timer?.cancel();
    final bug = _bugs[_currentIdx];

    if (idx == bug.correctOptionIndex) {
      _score += 150 + (_secondsLeft * 5);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🐛 BUG SQUASHED! ${bug.fixExplanation}'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Incorrect. Fix: ${bug.fixExplanation}'),
          backgroundColor: AppColors.danger,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_currentIdx < _bugs.length - 1) {
          setState(() {
            _currentIdx++;
          });
          _startTimer();
        } else {
          _onGameEnd();
        }
      }
    });
  }

  void _onTimeOut() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('⏳ Time expired on this bug!'), backgroundColor: AppColors.warning),
    );
    if (_currentIdx < _bugs.length - 1) {
      setState(() => _currentIdx++);
      _startTimer();
    } else {
      _onGameEnd();
    }
  }

  void _onGameEnd() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gamification = Provider.of<GamificationProvider>(context, listen: false);

    int stars = (_score >= 400) ? 3 : (_score >= 200) ? 2 : 1;
    int xp = 40;

    await gameProvider.recordGameResult(
      gameKey: 'code_bug_hunter',
      score: _score,
      stars: stars,
      xpEarned: xp,
      gamificationProvider: gamification,
    );

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('👾 DEBUGGING SPRINT COMPLETE!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⭐⭐⭐'.substring(0, stars), style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 10),
              Text('Score: $_score Points', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('+$xp XP Added to Your Profile! ⚡', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpGold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Back to Arcade'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _loadBugs();
              },
              child: const Text('Play Again 🔄'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIdx >= _bugs.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bug = _bugs[_currentIdx];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Code Bug Hunter 🐛'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HUD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${bug.language} • Bug ${_currentIdx + 1}/${_bugs.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                  ),
                  Text('⏳ $_secondsLeft s', style: TextStyle(fontWeight: FontWeight.bold, color: _secondsLeft <= 10 ? AppColors.danger : AppColors.textPrimary)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.xpGoldLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('🏆 $_score pts', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpGold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(bug.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 10),

              // Code Editor Window Mock
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                        const Spacer(),
                        Text(bug.language, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 18),
                    Text(
                      bug.buggyCode,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 13,
                        color: Color(0xFFF8F8F2),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text('How do you fix this bug?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: bug.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, idx) {
                    return InkWell(
                      onTap: () => _onAnswerChosen(idx),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                String.fromCharCode(65 + idx),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                bug.options[idx],
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
