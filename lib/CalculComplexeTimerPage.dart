import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Question {
  final String question;
  final int correctAnswer;
  final List<int> choices;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.choices,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      correctAnswer: json['correctAnswer'],
      choices: List<int>.from(json['choices']),
    );
  }
}

class CalculComplexeTimerPage extends StatefulWidget {
  // Paramètre pour activer ou non le timer
  final bool timerEnabled;

  const CalculComplexeTimerPage({Key? key, this.timerEnabled = true})
      : super(key: key);

  @override
  State<CalculComplexeTimerPage> createState() => _CalculComplexeTimerPageState();
}

class _CalculComplexeTimerPageState extends State<CalculComplexeTimerPage> {
  int _timeLeft = 30;
  Timer? _timer;
  List<Question> _questions = [];
  Question? _currentQuestion;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;

  String _feedbackText = "À toi de jouer !";
  String _emotionImage = 'assets/images/QT/emotions/heureux2.png';

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
    "assets/images/QT/emotions/presque.png",
    "assets/images/QT/emotions/inquiet.png",
    "assets/images/QT/emotions/inquiet2.png",
    "assets/images/QT/emotions/bizarre.png"
  ];

  final List<String> _successEmotions = [
    "assets/images/QT/emotions/heureux.png",
    "assets/images/QT/emotions/heureux3.png",
    "assets/images/QT/emotions/heureux4.png",
    "assets/images/QT/emotions/bisou.png"
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions().then((_) {
      if (widget.timerEnabled) {
        _startTimer();
      }
      _loadNextQuestion();
    });
  }

  Future<void> _loadQuestions() async {
    final String response =
    await rootBundle.loadString('assets/questions/calcul_parentheses.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _questions = data.map((q) => Question.fromJson(q)).toList();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _showGameOverDialog();
        }
      });
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Temps écoulé"),
        content: Text("Votre score est $_score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: const Text("Rejouer"),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _timeLeft = 30;
      _score = 0;
      _answered = false;
      _selectedAnswer = null;
    });
    if (widget.timerEnabled) {
      _startTimer();
    }
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    if (_questions.isNotEmpty) {
      final random = Random();
      setState(() {
        _currentQuestion = _questions[random.nextInt(_questions.length)];
        _answered = false;
        _selectedAnswer = null;
      });
    }
  }

  void _checkAnswer(int selectedAnswer) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedAnswer = selectedAnswer;

      if (selectedAnswer == _currentQuestion!.correctAnswer) {
        _score++;
        _feedbackText =
        _successMessages[Random().nextInt(_successMessages.length)];
        _emotionImage =
        _successEmotions[Random().nextInt(_successEmotions.length)];
      } else {
        _feedbackText = _failMessages[Random().nextInt(_failMessages.length)];
        _emotionImage = _failEmotions[Random().nextInt(_failEmotions.length)];
      }
    });

    // Si le timer est activé, passer automatiquement à la question suivante après 1 seconde.
    // Sinon, on attend que l'utilisateur appuie sur le bouton "Suivant".
    if (widget.timerEnabled) {
      Timer(const Duration(seconds: 1), () {
        _loadNextQuestion();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Fond et feedback
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
            // Image principale
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
                        _emotionImage,
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
                        colors: [
                          Colors.orange.shade300,
                          Colors.orange.shade500
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Afficher le timer seulement s'il est activé
                        if (widget.timerEnabled)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [TimerWidget(timeLeft: _timeLeft)],
                          ),
                        Text(
                          _currentQuestion?.question ?? 'Chargement...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: _currentQuestion != null
                              ? GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            children: _currentQuestion!.choices.map((choice) {
                              Color? buttonColor = Colors.white;
                              if (_answered) {
                                if (choice == _currentQuestion!.correctAnswer) {
                                  buttonColor = Colors.green;
                                } else if (choice == _selectedAnswer) {
                                  buttonColor = Colors.red;
                                }
                              }
                              return ReponseButton(
                                text: choice.toString(),
                                backgroundcolor: buttonColor,
                                onPressed: () {
                                  if (!_answered) {
                                    _checkAnswer(choice);
                                  }
                                },
                              );
                            }).toList(),
                          )
                              : const Center(child: CircularProgressIndicator()),
                        ),
                        // Si le timer est désactivé et qu'une réponse a été donnée, afficher un bouton "Suivant"
                        if (!widget.timerEnabled && _answered)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              onPressed: _loadNextQuestion,
                              child: const Text("Suivant"),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ReponseButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundcolor;

  const ReponseButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 80),
        textStyle: const TextStyle(fontSize: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: backgroundcolor ?? Colors.white,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD06F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$timeLeft',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}