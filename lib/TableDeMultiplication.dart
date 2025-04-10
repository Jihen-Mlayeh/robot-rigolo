import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

class TableDeMultiplication extends StatefulWidget {
  final bool timerEnabled;

  const TableDeMultiplication({
    Key? key,
    required this.timerEnabled,
  }) : super(key: key);

  @override
  State<TableDeMultiplication> createState() => _TableDeMultiplicationState();
}

class _TableDeMultiplicationState extends State<TableDeMultiplication> {
  int _selectedTable = 1;
  List<List<TextEditingController>> _controllers = [];
  List<List<bool>> _isCorrect = [];
  List<List<bool>> _isLocked = [];
  String _feedbackText = "À toi de jouer !";
  String _robotEmotion = 'assets/images/QT/emotions/heureux2.png';
  int _timeLeft = 180; // 180 secondes par défaut
  Timer? _timer;
  int _score = 0;

  final List<String> _successMessages = [
    "Génial !",
    "Super !",
    "Bien joué !",
    "Continue comme ça !",
    "Excellent !"
  ];

  final List<String> _failMessages = [
    "Dommage !",
    "Presque !",
    "Essaie encore !",
    "Oh non !",
    "Pas cette fois !"
  ];

  final List<String> _failEmotions = [
    'presque.png',
    'inquiet.png',
    'inquiet2.png',
    'bizarre.png'
  ];

  final List<String> _successEmotions = [
    'heureux.png',
    'heureux3.png',
    'heureux4.png',
    'bisou.png'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.timerEnabled) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Temps écoulé !"),
          content: Text("Votre score : $_score/50"),
          actions: <Widget>[
            TextButton(
              child: const Text("Rejouer"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _timeLeft = 180;
      _score = 0;
      _initializeControllers();
      if (widget.timerEnabled) {
        _startTimer();
      }
    });
  }

  void _initializeControllers() {
    _controllers = List.generate(
      9,
          (row) => List.generate(5, (col) => TextEditingController()),
    );
    _isCorrect = List.generate(9, (_) => List.filled(5, false));
    _isLocked = List.generate(9, (_) => List.filled(5, false));
  }

  void _checkAnswer(int row, int col, String value) {
    if (value.isEmpty || _isLocked[row][col]) return;

    final correctAnswer = ((row + 1) * (col + 1)).toString();
    final isCorrect = value == correctAnswer;

    setState(() {
      _isCorrect[row][col] = isCorrect;
      _isLocked[row][col] = true;

      if (isCorrect) {
        _score++;
        _feedbackText = _successMessages[Random().nextInt(_successMessages.length)];
        _robotEmotion = 'assets/images/QT/emotions/${_successEmotions[Random().nextInt(_successEmotions.length)]}';
      } else {
        _feedbackText = _failMessages[Random().nextInt(_failMessages.length)];
        _robotEmotion = 'assets/images/QT/emotions/${_failEmotions[Random().nextInt(_failEmotions.length)]}';
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var row in _controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF74F1F5),
      body: SafeArea(
        child: Stack(
          children: [
            // Partie haute : Bulle de dialogue
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 0, start: 0),
                  child: Image.asset(
                    'assets/images/other/chat-bubble-gauche.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    alignment: Alignment.topRight,
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 45,
                  child: Container(
                    width: 115,
                    height: 70,
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _feedbackText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Hellocute",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Partie haute : Tête du robot avec émotion
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 20),
                      child: Image.asset(
                        'assets/images/QT/QT_head.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.contain,
                        alignment: Alignment.topRight,
                      ),
                    ),
                    Positioned(
                      top: 41,
                      left: 50,
                      child: Image.asset(
                        _robotEmotion,
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        alignment: Alignment.topRight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),

            // Contenu principal (bas de page) : Table de multiplication modernisée
            Column(
              children: [
                const SizedBox(height: 150),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC232),
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF74A8F5), Color(0xFF74F1F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Timer et score
                        if (widget.timerEnabled)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TimerWidget(timeLeft: _timeLeft),
                                Text(
                                  'Score: $_score/50',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Nouvelle table de multiplication designée et responsive
                        Expanded(
                          child: MultiplicationTableGrid(
                            controllers: _controllers,
                            isCorrect: _isCorrect,
                            isLocked: _isLocked,
                            onCheckAnswer: _checkAnswer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final int timeLeft;

  const TimerWidget({
    Key? key,
    required this.timeLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '⏱ $timeLeft',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }
}
class MultiplicationTableGrid extends StatelessWidget {
  final List<List<TextEditingController>> controllers;
  final List<List<bool>> isCorrect;
  final List<List<bool>> isLocked;
  final Function(int, int, String) onCheckAnswer;

  const MultiplicationTableGrid({
    Key? key,
    required this.controllers,
    required this.isCorrect,
    required this.isLocked,
    required this.onCheckAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // On souhaite 6 cellules par ligne, chacune avec un padding de 4 px sur chaque côté.
      // Ce qui fait 8 pixels de padding par cellule.
      double totalPadding = 6 * 8;
      double cellWidth = (constraints.maxWidth - totalPadding) / 6;
      double cellHeight = cellWidth * 0.8;

      return SizedBox(
        width: constraints.maxWidth,
        child: Column(
          children: [
            // Ligne d'en-tête
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: cellWidth,
                    height: cellHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF74A8F5), Color(0xFF74F1F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: const Text(
                      '×',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                for (int i = 1; i <= 5; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: cellWidth,
                      height: cellHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF74A8F5), Color(0xFF74F1F5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: i == 5
                            ? const BorderRadius.only(topRight: Radius.circular(12))
                            : BorderRadius.zero,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: Text(
                        '$i',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Les lignes de données
            Expanded(
              child: ListView.builder(
                itemCount: controllers.length, // 9 lignes
                itemBuilder: (context, row) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        // Colonne pour le numéro de la ligne (multiplicateur)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: cellWidth,
                            height: cellHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                              ),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              '${row + 1}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Cellules pour les réponses
                        for (int col = 0; col < 5; col++)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: cellWidth,
                              height: cellHeight,
                              decoration: BoxDecoration(
                                color: controllers[row][col].text.isNotEmpty
                  ? (isCorrect[row][col]
                  ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3))
                      : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus &&
                                        controllers[row][col].text.isNotEmpty) {
                                      onCheckAnswer(row, col, controllers[row][col].text);
                                    }
                                  },
                                  child: TextField(
                                    controller: controllers[row][col],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    enabled: !isLocked[row][col],
                                    // On limite à 2 chiffres pour éviter un débordement
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2)
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      filled: true,
                                      fillColor:Colors.transparent,
                                    ),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: controllers[row][col].text.isNotEmpty
                                          ? (isCorrect[row][col]
                                          ? Colors.green
                                          : Colors.red)
                                          : Colors.black,
                                      decoration: controllers[row][col].text.isNotEmpty &&
                                          !isCorrect[row][col]
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}


