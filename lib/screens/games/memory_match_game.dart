import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/grade_level_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/gamification_provider.dart';

class MemoryCardItem {
  final int id;
  final String content;
  final String pairKey;
  final String subtitle;
  bool isFaceUp;
  bool isMatched;

  MemoryCardItem({
    required this.id,
    required this.content,
    required this.pairKey,
    this.subtitle = '',
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

class MemoryMatchGameScreen extends StatefulWidget {
  final GradeCategory gradeCategory;

  const MemoryMatchGameScreen({super.key, required this.gradeCategory});

  @override
  State<MemoryMatchGameScreen> createState() => _MemoryMatchGameScreenState();
}

class _MemoryMatchGameScreenState extends State<MemoryMatchGameScreen> {
  List<MemoryCardItem> _cards = [];
  MemoryCardItem? _firstSelected;
  MemoryCardItem? _secondSelected;
  bool _isBusy = false;
  int _moves = 0;
  int _matchedPairs = 0;
  int _secondsLeft = 60;
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initGame() {
    _moves = 0;
    _matchedPairs = 0;
    _secondsLeft = 60;
    _isGameOver = false;
    _firstSelected = null;
    _secondSelected = null;
    _isBusy = false;

    List<Map<String, dynamic>> rawPairs = [];

    if (widget.gradeCategory == GradeCategory.junior) {
      // Nursery / Primary Cards: Alphabet & Animal Matches
      rawPairs = [
        {'pair': 'apple', 'card1': '🍎 Apple', 'card2': 'Letter "A"', 'sub': 'Phonics'},
        {'pair': 'bear', 'card1': '🐻 Bear', 'card2': 'Letter "B"', 'sub': 'Phonics'},
        {'pair': 'cat', 'card1': '🐱 Cat', 'card2': 'Letter "C"', 'sub': 'Phonics'},
        {'pair': 'dog', 'card1': '🐶 Dog', 'card2': 'Letter "D"', 'sub': 'Phonics'},
        {'pair': 'star', 'card1': '⭐ Star', 'card2': 'Shape: Star', 'sub': 'Geometry'},
        {'pair': 'three', 'card1': '3️⃣ Three', 'card2': '🟢🟢🟢 Dots', 'sub': 'Counting'},
      ];
    } else if (widget.gradeCategory == GradeCategory.highSchool) {
      // High School Cards: Science & Math Concepts
      rawPairs = [
        {'pair': 'water', 'card1': 'H₂O', 'card2': 'Water Molecule', 'sub': 'Chemistry'},
        {'pair': 'gravity', 'card1': 'g = 9.8 m/s²', 'card2': 'Earth Gravity', 'sub': 'Physics'},
        {'pair': 'powerhouse', 'card1': 'Mitochondria', 'card2': 'Powerhouse of Cell', 'sub': 'Biology'},
        {'pair': 'pythagoras', 'card1': 'a² + b² = c²', 'card2': 'Pythagoras Theorem', 'sub': 'Math'},
        {'pair': 'speed', 'card1': 'Distance / Time', 'card2': 'Speed Formula', 'sub': 'Physics'},
        {'pair': 'salt', 'card1': 'NaCl', 'card2': 'Table Salt', 'sub': 'Chemistry'},
      ];
    } else {
      // College Cards: DSA, Math & DBMS
      rawPairs = [
        {'pair': 'bst', 'card1': 'Binary Search Tree', 'card2': 'O(log n) Search', 'sub': 'DSA'},
        {'pair': 'avl', 'card1': 'AVL Tree', 'card2': 'Strictly Balanced BST', 'sub': 'DSA'},
        {'pair': 'sql', 'card1': 'INNER JOIN', 'card2': 'Matching Rows Only', 'sub': 'DBMS'},
        {'pair': 'matrix', 'card1': 'Identity Matrix', 'card2': 'Det(I) = 1', 'sub': 'Math'},
        {'pair': 'state', 'card1': 'ChangeNotifier', 'card2': 'Provider State Flow', 'sub': 'Flutter'},
        {'pair': 'acid', 'card1': 'ACID Properties', 'card2': 'Atomicity & Isolation', 'sub': 'DBMS'},
      ];
    }

    List<MemoryCardItem> cardList = [];
    int idCounter = 1;
    for (final p in rawPairs) {
      cardList.add(MemoryCardItem(id: idCounter++, content: p['card1'], pairKey: p['pair'], subtitle: p['sub']));
      cardList.add(MemoryCardItem(id: idCounter++, content: p['card2'], pairKey: p['pair'], subtitle: p['sub']));
    }

    cardList.shuffle();
    setState(() => _cards = cardList);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        _onGameEnd(won: false);
      }
    });
  }

  void _onCardTapped(MemoryCardItem card) {
    if (_isBusy || card.isFaceUp || card.isMatched) return;

    setState(() {
      card.isFaceUp = true;
    });

    if (_firstSelected == null) {
      _firstSelected = card;
    } else {
      _secondSelected = card;
      _moves++;
      _isBusy = true;

      if (_firstSelected!.pairKey == _secondSelected!.pairKey) {
        // MATCH!
        _firstSelected!.isMatched = true;
        _secondSelected!.isMatched = true;
        _matchedPairs++;
        _firstSelected = null;
        _secondSelected = null;
        _isBusy = false;

        if (_matchedPairs == (_cards.length ~/ 2)) {
          _timer?.cancel();
          _onGameEnd(won: true);
        }
      } else {
        // NO MATCH -> Flip back after delay
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            setState(() {
              _firstSelected?.isFaceUp = false;
              _secondSelected?.isFaceUp = false;
              _firstSelected = null;
              _secondSelected = null;
              _isBusy = false;
            });
          }
        });
      }
    }
  }

  void _onGameEnd({required bool won}) async {
    setState(() => _isGameOver = true);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final gamification = Provider.of<GamificationProvider>(context, listen: false);

    int stars = 1;
    if (_moves <= 10 && _secondsLeft > 25) {
      stars = 3;
    } else if (_moves <= 16) {
      stars = 2;
    }

    int score = won ? (_secondsLeft * 10) + (stars * 100) : 50;
    int xp = won ? 30 : 10;

    await gameProvider.recordGameResult(
      gameKey: 'memory_match',
      score: score,
      stars: won ? stars : 0,
      xpEarned: xp,
      gamificationProvider: gamification,
    );

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(won ? '🎉 STAGE CLEARED!' : '⏳ TIME OUT!', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(won ? '⭐⭐⭐'.substring(0, stars) : '💔', style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 10),
              Text('Score: $score pts • Completed in $_moves moves', style: const TextStyle(fontSize: 14)),
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
                _initGame();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Memory Match & Concept Flip 🃏'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header HUD (Time, Moves, Matches)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHUDItem('⏳ Time', '$_secondsLeft s', AppColors.primary),
                    _buildHUDItem('🎯 Moves', '$_moves', AppColors.warning),
                    _buildHUDItem('✅ Pairs', '$_matchedPairs/${_cards.length ~/ 2}', AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card Grid (3x4)
              Expanded(
                child: GridView.builder(
                  itemCount: _cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (ctx, idx) {
                    final card = _cards[idx];
                    final isRevealed = card.isFaceUp || card.isMatched;

                    return GestureDetector(
                      onTap: () => _onCardTapped(card),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: card.isMatched
                              ? AppColors.successLight
                              : isRevealed
                                  ? AppColors.surface
                                  : AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: card.isMatched
                                ? AppColors.success
                                : isRevealed
                                    ? AppColors.primary
                                    : AppColors.primaryDark,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: isRevealed
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    card.content,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: card.isMatched ? AppColors.success : AppColors.textPrimary,
                                    ),
                                  ),
                                  if (card.subtitle.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      card.subtitle,
                                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                    ),
                                  ],
                                ],
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('❓', style: TextStyle(fontSize: 26)),
                                  SizedBox(height: 4),
                                  Text('FLIP', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
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

  Widget _buildHUDItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }
}
