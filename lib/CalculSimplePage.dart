import 'package:flutter/material.dart';
import 'dart:async';


class CalculSimplePage extends StatefulWidget {
  const CalculSimplePage({Key? key}) : super(key: key);

  @override
  State<CalculSimplePage> createState() => _CalculSimplePageState();
}

class _CalculSimplePageState extends State<CalculSimplePage> {
  int _timeLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          // Quand le temps est écoulé
          _timer?.cancel();
          // Vous pouvez déclencher une action, ex. passer à l'écran suivant
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fond général blanc
      backgroundColor: Colors.white,
      body: SafeArea(
        child:

        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  Image.asset(
                  'assets/images/other/chat-bubble-gauche.png',
                  width: 125,
                  height: 125,
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                )
                ,
                Image.asset(
                  'assets/images/QT/QT_speak.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                ),
                const SizedBox(width: 20),
              ],
            )

          ,

            Column(
              children: [

                const SizedBox(height: 150),
                // Container vert qui englobe l'addition et les boutons
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC232),
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
                          ]
                          ,

                        )
                        ,
                        // Addition (question)
                        const Text(
                          '2 + 5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Boutons de réponse en grille (2 par ligne)
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2, // 2 colonnes
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            children: [
                              ReponseButton(
                                text: '9',
                                onPressed: () {
                                  // Action pour le bouton "9"
                                },
                              ),
                              ReponseButton(
                                text: '6',
                                onPressed: () {
                                  // Action pour le bouton "6"
                                },
                              ),
                              ReponseButton(
                                text: '8',
                                onPressed: () {
                                  // Action pour le bouton "8"
                                },
                              ),
                              ReponseButton(
                                text: '7',
                                onPressed: () {
                                  // Action pour le bouton "7"
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )

       ]
      )

        ,
      ),
    );
  }
}

class ReponseButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ReponseButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Action au clic
      onPressed: onPressed,
      // Style du bouton
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 80),      // Hauteur (80) plus grande que la normale
        textStyle: const TextStyle(fontSize: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,  // Couleur de fond du bouton
      ),
      // Texte du bouton
      child: Text(text,style: TextStyle(color: Colors.black),),
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
        color: Color(0xFFFFD06F),
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