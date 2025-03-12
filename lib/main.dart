import 'package:calculs/ButtonMain.dart';
import 'package:calculs/ChoiceExPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _textOpacity;

  bool isSpeaking = false; // État du robot (parle ou non)

  @override
  void initState() {
    super.initState();

    // Animation du robot (léger mouvement)
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );


    // Démarrer l'animation de parole
    _startSpeakingAnimation();
  }

  void _startSpeakingAnimation() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isSpeaking = true; // Passe à l’image du robot qui parle
        });

        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              isSpeaking = false; // Retour à l'image normale après 2 sec
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/other/background3.png"),
              fit: BoxFit.fitHeight,
          )),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bienvenue !",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                ),
                SizedBox(height: 20),

                // Animation du robot avec changement d'image
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: Image.asset(
                        isSpeaking ? 'assets/images/QT/QT_speak.png' : 'assets/images/QT/QT_salute.png',
                        width: 200,
                      ),
                    );
                  },
                ),

                SizedBox(height: 40),

                // Bouton "Commencer"
                ButtonMain(text: "Commencer", onPressed: (){})
              ],
            ),
          ],
        ),
      )

      );
  }
}