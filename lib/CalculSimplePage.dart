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

class CalculSimplePage extends StatefulWidget {
  const CalculSimplePage({Key? key}) : super(key: key);

  @override
  State<CalculSimplePage> createState() => _CalculSimplePageState();
}

class _CalculSimplePageState extends State<CalculSimplePage> {
  int _timeLeft = 30;
  Timer? _timer;
  List<Question> _questions = [];
  Question? _currentQuestion;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestions().then((_) {
      _startTimer();
      _loadNextQuestion();
    });
  }

  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions/simple_calcul.json');
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
    _startTimer();
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
      }
    });
    // Attendre 1 seconde pour afficher le feedback avant de passer à la question suivante
    Timer(const Duration(seconds: 1), () {
      _loadNextQuestion();
    });
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
            Stack(
              children: [

                Padding(padding: EdgeInsetsDirectional.only(top: 0,start: 0),
                  child:  Image.asset(
                    'assets/images/other/chat-bubble-gauche.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    alignment: Alignment.topRight,
                  ),
                ),


                Positioned(child:
                Container(
                  width: 110,
                  height: 110,
                  child: Text(
                    "à toi de jouer !",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                  left: 40,
                  top: 30,
                )

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [


                Stack(
                  children: [

                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 20),
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
                        'assets/images/QT/emotions/heureux2.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        alignment: Alignment.topRight,
                      ),),
                  ],
                ),
                const SizedBox(width: 20),
              ],
            ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TimerWidget(timeLeft: _timeLeft)
                          ],
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
  Color? backgroundcolor;

  ReponseButton({
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
