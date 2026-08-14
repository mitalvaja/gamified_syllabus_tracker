import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/grade_level_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/gamification_provider.dart';

class SpeedMathGameScreen extends StatefulWidget {
  final GradeCategory gradeCategory;

  const SpeedMathGameScreen({super.key, required this.gradeCategory});

  @override
  State<SpeedMathGameScreen> createState() => _SpeedMathGameScreenState();
}

class _SpeedMathGameScreenState extends State<SpeedMathGameScreen> {
  int _score = 0;
  int _combo = 0;
  int _secondsLeft = 45;
  Timer? _timer;
  bool _isGameOver = false;

  String _currentQuestion = '';
  int _correctAnswer = 0;
  List<int> _options = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _score = 0;
    _combo = 0;
    _secondsLeft = 45;
    _isGameOver = false;
    _generateNextQuestion();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        _onGameOver();
      }
    });
  }

  void _generateNextQuestion() {
    int a = 0;
    int b = 0;
    String op = '+';
    int ans = 0;

    if (widget.gradeCategory == GradeCategory.junior) {
      // Junior: Simple addition / subtraction (1 to 20)
      a = _rnd.nextInt(12) + 1;
      b = _rnd.nextInt(10) + 1;
      if (_rnd.nextBool()) {
        op = '+';
        ans = a + b;
      } else {
        if (a < b) {
          int temp = a; a = b; b = temp;
        }
        op = '-';
        ans = a - b;
      }
    } else if (widget.gradeCategory == GradeCategory.highSchool) {
      // High School: Multiplication, Division, Pre-Algebra
      final type = _rnd.nextInt(3);
      if (type == 0) {
        a = _rnd.nextInt(12) + 3;
        b = _rnd.nextInt(12) + 2;
        op = '×';
        ans = a * b;
      } else if (type == 1) {
        b = _rnd.nextInt(10) + 2;
        ans = _rnd.nextInt(10) + 1;
        a = ans * b;
        op = '÷';
      } else {
        a = _rnd.nextInt(15) + 5;
        b = _rnd.nextInt(15) + 5;
        op = '+';
        ans = a + b;
      }
    } else {
      // College: Modulo, Squares, Powers, Matrix Determinants (2x2)
      final type = _rnd.nextInt(3);
      if (type == 0) {
        a = _rnd.nextInt(20) + 10;
        b = _rnd.nextInt(8) + 2;
        op = '% (mod)';
        ans = a % b;
      } else if (type == 1) {
        a = _rnd.nextInt(16) + 2;
        op = '² (Square)';
        b = 0;
        ans = a * a;
      } else {
        // 2x2 Det: |a  b| / |c  d|
        int c = _rnd.nextInt(4) + 1;
        int d = _rnd.nextInt(4) + 1;
        a = _rnd.nextInt(4) + 1;
        b = _rnd.nextInt(4) + 1;
        _currentQuestion = 'Det | $a  $b |\n    | $c  $d |';
        _correctAnswer = (a * d) - (b * c);
        _buildOptions(_correctAnswer);
        setState(() {});
        return;
      }
    }

    _currentQuestion = (b == 0) ? '$a$op' : '$a $op $b = ?';
    _correctAnswer = ans;
    _buildOptions(_correctAnswer);
    setState(() {});
  }

  void _buildOptions(int correct) {
    final Set<int> opts = {correct};
    while (opts.length < 4) {
      int delta = _rnd.nextInt(9) - 4;
      if (delta == 0) delta = 5;
      opts.add(correct + delta);
    }
    _options = opts.toList()..shuffle();
  }

  void _onAnswerSelected(int chosen) {
    if (_isGameOver) return;

    if (chosen == _correctAnswer) {
      _combo++;
      final multiplier = (_combo >= 5) ? 3 : (_combo >= 3) ? 2 : 1;
      _score += (10 * multiplier);
      _generateNextQuestion();
    } else {
      _combo = 0;
      _score = max(0, _score - 5);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Oops! Correct was $_correctAnswer'),
          duration: const Duration(milliseconds: 600),
          backgroundColor: AppColors.danger,
        ),
      );
      _generateNextQuestion();
    }
  }

  void _onGameOver() async {
    setState(() => _isGameOver = true);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gamification = Provider.of<GamificationProvider>(context, listen: false);

    int stars = (_score >= 250) ? 3 : (_score >= 120) ? 2 : (_score > 0) ? 1 : 0;
    int xp = (_score >= 200) ? 35 : 15;

    await gameProvider.recordGameResult(
      gameKey: 'speed_math',
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
          title: const Text('⚡ TIME IS UP!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⭐⭐⭐'.substring(0, stars), style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 10),
              Text('Final Score: $_score Points 🎯', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              child: const Text('Exit Arcade'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _startGame();
              },
              child: const Text('Play Again ⚡'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Speed Math Lightning ⚡'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top Score & Timer HUD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('🏆 Score: $_score', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                  if (_combo > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.xpGoldLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('🔥 ${_combo}x Combo!', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpGold)),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _secondsLeft <= 10 ? AppColors.dangerLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _secondsLeft <= 10 ? AppColors.danger : AppColors.cardBorder),
                    ),
                    child: Text('⏳ $_secondsLeft s', style: TextStyle(fontWeight: FontWeight.bold, color: _secondsLeft <= 10 ? AppColors.danger : AppColors.textPrimary)),
                  ),
                ],
              ),
              const Spacer(),

              // Question Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  _currentQuestion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const Spacer(),

              // 4 Choice Buttons
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: _options.map((opt) {
                  return ElevatedButton(
                    onPressed: () => _onAnswerSelected(opt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
                      ),
                    ),
                    child: Text(
                      '$opt',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
