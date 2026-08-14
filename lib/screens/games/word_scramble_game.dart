import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/grade_level_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/gamification_provider.dart';

class WordPuzzleItem {
  final String word;
  final String clue;
  final String category;

  const WordPuzzleItem({required this.word, required this.clue, required this.category});
}

class WordScrambleGameScreen extends StatefulWidget {
  final GradeCategory gradeCategory;

  const WordScrambleGameScreen({super.key, required this.gradeCategory});

  @override
  State<WordScrambleGameScreen> createState() => _WordScrambleGameScreenState();
}

class _WordScrambleGameScreenState extends State<WordScrambleGameScreen> {
  int _score = 0;
  int _currentPuzzleIdx = 0;
  List<WordPuzzleItem> _puzzles = [];
  List<String> _scrambledLetters = [];
  List<String> _userLetters = [];

  @override
  void initState() {
    super.initState();
    _loadPuzzles();
  }

  void _loadPuzzles() {
    if (widget.gradeCategory == GradeCategory.junior) {
      _puzzles = [
        const WordPuzzleItem(word: 'APPLE', clue: 'A juicy red sweet fruit 🍎', category: 'Kids Vocabulary'),
        const WordPuzzleItem(word: 'TIGER', clue: 'The striped wild cat of the jungle 🐅', category: 'Animals'),
        const WordPuzzleItem(word: 'ZEBRA', clue: 'Animal with black & white stripes 🦓', category: 'Animals'),
        const WordPuzzleItem(word: 'WATER', clue: 'Essential liquid we drink every day 💧', category: 'Nature'),
      ];
    } else if (widget.gradeCategory == GradeCategory.highSchool) {
      _puzzles = [
        const WordPuzzleItem(word: 'GRAVITY', clue: 'Force pulling objects toward Earth 🌍', category: 'Physics'),
        const WordPuzzleItem(word: 'OXYGEN', clue: 'Gas essential for human respiration 💨', category: 'Chemistry'),
        const WordPuzzleItem(word: 'CELL', clue: 'Basic structural unit of life 🔬', category: 'Biology'),
        const WordPuzzleItem(word: 'VOLCANO', clue: 'Rupture in Earth crust expelling lava 🌋', category: 'Geography'),
      ];
    } else {
      _puzzles = [
        const WordPuzzleItem(word: 'FLUTTER', clue: 'Cross-platform UI toolkit by Google 📱', category: 'Mobile App Dev'),
        const WordPuzzleItem(word: 'DATABASE', clue: 'Organized collection of structured data 🗄️', category: 'DBMS'),
        const WordPuzzleItem(word: 'BINARY', clue: 'Base-2 numbering system in computers 💻', category: 'Computer Science'),
        const WordPuzzleItem(word: 'SCHEMA', clue: 'Structural blueprint of database tables 📐', category: 'SQL & DB'),
      ];
    }

    _puzzles.shuffle();
    _currentPuzzleIdx = 0;
    _score = 0;
    _setupCurrentPuzzle();
  }

  void _setupCurrentPuzzle() {
    if (_currentPuzzleIdx >= _puzzles.length) {
      _onGameComplete();
      return;
    }

    final target = _puzzles[_currentPuzzleIdx].word;
    List<String> chars = target.split('');
    chars.shuffle(Random());
    while (chars.join('') == target && target.length > 2) {
      chars.shuffle(Random());
    }

    setState(() {
      _scrambledLetters = chars;
      _userLetters = [];
    });
  }

  void _onLetterTapped(int index) {
    if (index >= _scrambledLetters.length) return;
    final char = _scrambledLetters[index];
    setState(() {
      _scrambledLetters.removeAt(index);
      _userLetters.add(char);
    });

    final target = _puzzles[_currentPuzzleIdx].word;
    if (_userLetters.length == target.length) {
      final formedWord = _userLetters.join('');
      if (formedWord == target) {
        _score += 100;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Correct! Word Cleared! +100 Pts'),
            backgroundColor: AppColors.success,
            duration: Duration(milliseconds: 700),
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _currentPuzzleIdx++;
            _setupCurrentPuzzle();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Not quite right! Resetting word...'),
            backgroundColor: AppColors.danger,
            duration: Duration(milliseconds: 600),
          ),
        );
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            _setupCurrentPuzzle();
          }
        });
      }
    }
  }

  void _onGameComplete() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gamification = Provider.of<GamificationProvider>(context, listen: false);

    int stars = (_score >= 300) ? 3 : (_score >= 100) ? 2 : 1;
    int xp = 30;

    await gameProvider.recordGameResult(
      gameKey: 'word_scramble',
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
          title: const Text('🏆 PUZZLE MASTERED!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⭐⭐⭐'.substring(0, stars), style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 10),
              Text('Score: $_score Points 🔤', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                _loadPuzzles();
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
    if (_currentPuzzleIdx >= _puzzles.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final puzzle = _puzzles[_currentPuzzleIdx];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Word & Concept Scramble 🔤'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top HUD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Puzzle ${_currentPuzzleIdx + 1}/${_puzzles.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.xpGoldLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('⭐ $_score pts', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpGold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Clue Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(puzzle.category, style: const TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      puzzle.clue,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // User Selected Letters (Answer Slots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(puzzle.word.length, (idx) {
                  final hasLetter = idx < _userLetters.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 44,
                    height: 52,
                    decoration: BoxDecoration(
                      color: hasLetter ? AppColors.primary : AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: hasLetter ? AppColors.primary : AppColors.border, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      hasLetter ? _userLetters[idx] : '',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Available Scrambled Letter Tiles
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(_scrambledLetters.length, (idx) {
                  return GestureDetector(
                    onTap: () => _onLetterTapped(idx),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.cardBorder, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _scrambledLetters[idx],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _setupCurrentPuzzle,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset Letters'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
