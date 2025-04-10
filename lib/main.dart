import 'package:calculs/AgeSelectionPage.dart';
import 'package:calculs/ButtonMain.dart';
import 'package:calculs/GameListPageFacile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot rigolo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black45,
          ),
        ),
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
            Padding(padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.20),
            child:
            Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Text(
                  "Bienvenue !",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Hellocute", letterSpacing: 2,height: 2)
                ),


                SizedBox(height: 0),

                // Animation du robot avec changement d'image
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: Image.asset(
                        'assets/images/QT/QT_head.png',
                        width: 150,
                      ),
                    );
                  },
                ),

                SizedBox(height: 5),

                // Bouton "Commencer"
                Row(
                  children: [
                    SizedBox(width: 15),
                    ButtonMain(text: "Commencer", onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AgeSelectionPage()));
                    })
                  ],
                )

              ],
            ),
            )

          ],
        ),
      )

      );
  }
}