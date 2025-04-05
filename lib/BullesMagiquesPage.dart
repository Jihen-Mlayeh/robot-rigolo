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

class BullesMagiquesPage extends StatefulWidget {
  const BullesMagiquesPage({Key? key}) : super(key: key);

  @override
  _BullesMagiquesPageState createState() => _BullesMagiquesPageState();
}

class _BullesMagiquesPageState extends State<BullesMagiquesPage> {
  final Random _random = Random();
  int _score = 0;
  Question? _currentQuestion;
  List<Question> _questions = [];
  final List<BubbleData> _bubbles = [];
  Timer? _bubbleGenerator;

  // Listes pour les messages et images d'échec
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

  @override
  void initState() {
    super.initState();
    _loadQuestions().then((_) {
      _loadNextQuestion();
      _startBubbleGeneration();
    });
  }

  Future<void> _loadQuestions() async {
    final String response =
    await rootBundle.loadString('assets/questions/simple_calcul.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _questions = data.map((q) => Question.fromJson(q)).toList();
    });
  }

  void _loadNextQuestion() {
    if (_questions.isNotEmpty) {
      setState(() {
        // Choisir une question aléatoire dans la liste
        _currentQuestion = _questions[_random.nextInt(_questions.length)];

      });
    }
  }

  void _startBubbleGeneration() {
    // Génère une nouvelle bulle toutes les secondes
    _bubbleGenerator = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentQuestion == null) return;
      setState(() {
        // Avec 50% de chance, la bulle affiche la bonne réponse
        int number = _random.nextBool()
            ? _currentQuestion!.correctAnswer
            : _random.nextInt(100);
        _bubbles.add(BubbleData(
          id: _random.nextInt(10000),
          number: number,
          left: _random.nextDouble() * 300, // Position horizontale (à ajuster)
        ));
      });
    });
  }

  void _onBubbleTap(BubbleData bubble) {
    if (_currentQuestion == null) return;
    if (bubble.number == _currentQuestion!.correctAnswer) {
      // Bonne réponse : augmenter le score et déclencher une animation de succès si souhaité
      setState(() {
        _score++;
      });
      // Retirer la bulle tapée et charger la prochaine question après 1 seconde
      setState(() {
        _bubbles.removeWhere((b) => b.id == bubble.id);
      });
      Timer(const Duration(seconds: 0), () {
        _loadNextQuestion();
      });
    } else {
      // Mauvaise réponse : affiche un SnackBar avec message et image aléatoires
      final String message = _failMessages[_random.nextInt(_failMessages.length)];
      final String emotionPath = _failEmotions[_random.nextInt(_failEmotions.length)];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0.1,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          content: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [

                Stack(
                  children: [


                    Image.asset(
                      'assets/images/QT/QT_head.png',
                      height: 150,
                      width: 150,
                    ),
                    Positioned(
                      child: Image.asset(
                        emotionPath,
                        height: 50,
                        width: 50,
                      ),
                      left: 50,
                      top: 10,
                    )

                  ],
                ),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),

        ),
      );
      setState(() {
        _bubbles.removeWhere((b) => b.id == bubble.id);
      });
    }
  }

  @override
  void dispose() {
    _bubbleGenerator?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Zone en haut : question et score
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    _currentQuestion?.question ?? "Chargement...",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Score: $_score",
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Affichage des bulles animées
            ..._bubbles.map((bubble) => BubbleWidget(
              bubbleData: bubble,
              onTap: () => _onBubbleTap(bubble),
              screenHeight: screenSize.height,
            )),
          ],
        ),
      ),
    );
  }
}

class BubbleData {
  final int id;
  final int number;
  final double left;
  BubbleData({required this.id, required this.number, required this.left});
}

class BubbleWidget extends StatefulWidget {
  final BubbleData bubbleData;
  final VoidCallback onTap;
  final double screenHeight;
  const BubbleWidget({
    Key? key,
    required this.bubbleData,
    required this.onTap,
    required this.screenHeight,
  }) : super(key: key);

  @override
  _BubbleWidgetState createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation = Tween<double>(begin: widget.screenHeight, end: -80)
        .animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            setState(() {});
          }
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (_animation.value < -80) return const SizedBox();
        return Positioned(
          top: _animation.value,
          left: widget.bubbleData.left,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.primaries[widget.bubbleData.id % Colors.primaries.length],
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                widget.bubbleData.number.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
