import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/grade_level_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/gamification_provider.dart';

class BattleQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final int damagePower; // 50, 90, 150

  const BattleQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.damagePower,
  });
}

class BossBattleGameScreen extends StatefulWidget {
  final GradeCategory gradeCategory;

  const BossBattleGameScreen({super.key, required this.gradeCategory});

  @override
  State<BossBattleGameScreen> createState() => _BossBattleGameScreenState();
}

class _BossBattleGameScreenState extends State<BossBattleGameScreen> {
  int _playerHp = 100;
  int _bossHp = 300;
  final int _bossMaxHp = 300;
  final int _playerMaxHp = 100;

  String _bossName = 'The Final Semester Boss';
  String _bossAvatar = '👹';
  String _battleLog = '⚔️ Battle started! Answer syllabus questions to strike the boss!';

  List<BattleQuestion> _questions = [];
  int _currentQuestionIdx = 0;
  bool _isActionInProgress = false;

  @override
  void initState() {
    super.initState();
    _initBoss();
  }

  void _initBoss() {
    _playerHp = 100;
    _bossHp = 300;
    _currentQuestionIdx = 0;
    _isActionInProgress = false;

    if (widget.gradeCategory == GradeCategory.junior) {
      _bossName = 'The Giant Number Monster';
      _bossAvatar = '👾';
      _questions = [
        const BattleQuestion(question: 'How many days are there in a week?', options: ['5', '6', '7', '10'], correctIndex: 2, damagePower: 75),
        const BattleQuestion(question: 'Which letter comes after "M" in the alphabet?', options: ['L', 'N', 'O', 'P'], correctIndex: 1, damagePower: 80),
        const BattleQuestion(question: 'What shape has 3 sides and 3 corners?', options: ['Square', 'Circle', 'Triangle', 'Rectangle'], correctIndex: 2, damagePower: 90),
        const BattleQuestion(question: '8 + 7 = ?', options: ['13', '14', '15', '16'], correctIndex: 2, damagePower: 100),
      ];
    } else if (widget.gradeCategory == GradeCategory.highSchool) {
      _bossName = 'The Science & Algebra Dragon';
      _bossAvatar = '🐉';
      _questions = [
        const BattleQuestion(question: 'What is the chemical symbol for Gold?', options: ['Ag', 'Au', 'Fe', 'Cu'], correctIndex: 1, damagePower: 80),
        const BattleQuestion(question: 'If 2x + 6 = 18, what is the value of x?', options: ['4', '6', '8', '12'], correctIndex: 1, damagePower: 90),
        const BattleQuestion(question: 'Which organ pumps oxygenated blood in the human body?', options: ['Lungs', 'Brain', 'Heart', 'Liver'], correctIndex: 2, damagePower: 90),
        const BattleQuestion(question: 'What is the SI unit of electric current?', options: ['Volt', 'Ampere', 'Watt', 'Ohm'], correctIndex: 1, damagePower: 110),
      ];
    } else {
      _bossName = 'The BCA Semester V Titan';
      _bossAvatar = '🤖';
      _questions = [
        const BattleQuestion(question: 'What is the average time complexity of Binary Search?', options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'], correctIndex: 1, damagePower: 80),
        const BattleQuestion(question: 'Which normal form eliminates partial functional dependency?', options: ['1NF', '2NF', '3NF', 'BCNF'], correctIndex: 1, damagePower: 90),
        const BattleQuestion(question: 'In Flutter, which widget is used for state propagation without rebuild loops?', options: ['InheritedWidget / Provider', 'Container', 'SizedBox', 'Column'], correctIndex: 0, damagePower: 100),
        const BattleQuestion(question: 'What is the determinant of a 2x2 matrix |3 2| / |1 4|?', options: ['10', '14', '12', '8'], correctIndex: 0, damagePower: 120),
      ];
    }

    _questions.shuffle(Random());
    setState(() {});
  }

  void _onAttackChosen(int optionIdx) {
    if (_isActionInProgress || _playerHp <= 0 || _bossHp <= 0) return;

    final q = _questions[_currentQuestionIdx];
    setState(() => _isActionInProgress = true);

    if (optionIdx == q.correctIndex) {
      // Player attack success!
      final dmg = q.damagePower;
      final newBossHp = max(0, _bossHp - dmg);
      setState(() {
        _bossHp = newBossHp;
        _battleLog = '⚡ CRITICAL HIT! You attacked $_bossName for $dmg Damage!';
      });

      if (_bossHp <= 0) {
        _onVictory();
        return;
      }
    } else {
      // Player attack failed -> Boss strikes back!
      final bossDmg = 25;
      final newPlayerHp = max(0, _playerHp - bossDmg);
      setState(() {
        _playerHp = newPlayerHp;
        _battleLog = '💥 OUCH! Wrong answer. $_bossName attacked you for $bossDmg Damage!';
      });

      if (_playerHp <= 0) {
        _onDefeat();
        return;
      }
    }

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _currentQuestionIdx = (_currentQuestionIdx + 1) % _questions.length;
          _isActionInProgress = false;
        });
      }
    });
  }

  void _onVictory() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gamification = Provider.of<GamificationProvider>(context, listen: false);

    await gameProvider.recordGameResult(
      gameKey: 'boss_battle',
      score: 1000,
      stars: 3,
      xpEarned: 100,
      gamificationProvider: gamification,
    );

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('👑 BOSS DEFEATED!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🏆 ⭐⭐⭐', style: TextStyle(fontSize: 34)),
              const SizedBox(height: 10),
              Text('You conquered $_bossName!', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('+100 BONUS XP & Rare "Boss Slayer" Badge Unlocked! ⚡', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpGold)),
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
                _initBoss();
              },
              child: const Text('Fight Again ⚔️'),
            ),
          ],
        ),
      );
    }
  }

  void _onDefeat() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('💀 DEFEAT', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💔', style: TextStyle(fontSize: 34)),
            const SizedBox(height: 10),
            Text('$_bossName overwhelmed your defenses. Revise your syllabus topics and try again!'),
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
              _initBoss();
            },
            child: const Text('Revive & Retry 🔄'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Scaffold();
    final q = _questions[_currentQuestionIdx];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Syllabus Boss Battle ⚔️', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Boss Display & HP Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.danger.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(_bossAvatar, style: const TextStyle(fontSize: 44)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_bossName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: _bossHp / _bossMaxHp,
                                        minHeight: 10,
                                        backgroundColor: Colors.white12,
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.danger),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('$_bossHp/$_bossMaxHp HP', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Player HP Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text('🛡️ You:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _playerHp / _playerMaxHp,
                          minHeight: 8,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$_playerHp/$_playerMaxHp HP', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Battle Action Log
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _battleLog,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),

              const Spacer(),

              // Question Dialogue Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Attack Power: ${q.damagePower} DMG ⚔️', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Attack Choices Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.3,
                children: List.generate(q.options.length, (idx) {
                  return ElevatedButton(
                    onPressed: _isActionInProgress ? null : () => _onAttackChosen(idx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF475569)),
                      ),
                    ),
                    child: Text(
                      q.options[idx],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
