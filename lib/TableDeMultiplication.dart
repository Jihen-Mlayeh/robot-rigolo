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
  int _timeLeft = 30; // 30 secondes par défaut
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
          content: Text("Votre score: $_score/50"),
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
      _timeLeft = 30;
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
          (row) => List.generate(
        5,
            (col) => TextEditingController(),
      ),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Bulle de dialogue
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
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _feedbackText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Tête du robot avec émotion
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

            // Contenu principal
            Column(
              children: [
                const SizedBox(height: 150),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC232),
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade300, Colors.orange.shade500],
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

                        // Table de multiplication avec champs de saisie
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: 10,
                                dataRowHeight: 50,
                                headingRowHeight: 50,
                                columns: [
                                  const DataColumn(label: Text('×', style: TextStyle(fontSize: 20))),
                                  for (int i = 1; i <= 5; i++)
                                    DataColumn(label: Text('$i', style: const TextStyle(fontSize: 20))),
                                ],
                                rows: [
                                  for (int row = 1; row <= 9; row++)
                                    DataRow(
                                      cells: [
                                        DataCell(Text('$row', style: const TextStyle(fontSize: 20))),
                                        for (int col = 1; col <= 5; col++)
                                          DataCell(
                                            SizedBox(
                                              width: 50,
                                              height: 40,
                                              child: Focus(
                                                onFocusChange: (hasFocus) {
                                                  if (!hasFocus && _controllers[row-1][col-1].text.isNotEmpty) {
                                                    _checkAnswer(row-1, col-1, _controllers[row-1][col-1].text);
                                                  }
                                                },
                                                child: TextField(
                                                  controller: _controllers[row-1][col-1],
                                                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  textAlign: TextAlign.center,
                                                  enabled: !_isLocked[row-1][col-1],
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    contentPadding: EdgeInsets.zero,
                                                    filled: _controllers[row-1][col-1].text.isNotEmpty,
                                                    fillColor: _controllers[row-1][col-1].text.isNotEmpty
                                                        ? (_isCorrect[row-1][col-1]
                                                        ? Colors.green.withOpacity(0.3)
                                                        : Colors.red.withOpacity(0.3))
                                                        : Colors.white,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: _controllers[row-1][col-1].text.isNotEmpty
                                                        ? (_isCorrect[row-1][col-1]
                                                        ? Colors.green
                                                        : Colors.red)
                                                        : Colors.black,
                                                    decoration: _controllers[row-1][col-1].text.isNotEmpty && !_isCorrect[row-1][col-1]
                                                        ? TextDecoration.lineThrough
                                                        : null,
                                                    decorationColor: Colors.red,
                                                    decorationThickness: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
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