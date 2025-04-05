
import 'package:calculs/GameListPageFacile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'DifficultySelectionPage.dart';  // Importer la page de sélection de niveau de difficulté

class AgeSelectionPage extends StatefulWidget {
  @override
  _AgeSelectionPageState createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  int selectedAge = 5;
  FixedExtentScrollController _controller = FixedExtentScrollController(initialItem: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/other/background3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Titre avec l'âge sélectionné
              Text(
                "Quel est ton age ?",
                style: GoogleFonts.comicNeue(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),

              // Conteneur pour le sélecteur d'âge
              Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: 50,
                  physics: FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedAge = index + 5;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          (index + 5).toString(),
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    childCount: 7,
                  ),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Tu as $selectedAge ans !",
                style: GoogleFonts.comicNeue(
                  fontSize:30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // Bouton bien positionné
              GestureDetector(
                onTapDown: (_) => HapticFeedback.lightImpact(),
                child: AnimatedContainer(
                  width: 250,
                  height: 70,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Redirection en fonction de l'âge sélectionné
                        if (selectedAge >= 8 && selectedAge <= 11) {
                          // Naviguer vers la page de sélection de difficulté
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DifficultySelectionPage(age: selectedAge),
                            ),
                          );
                        } else if (selectedAge >= 5 && selectedAge <= 7) {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameListPageFacile(),
                            ),
                          );
                        } else {
                          // Par exemple, revenir à la page précédente ou rediriger vers une autre page
                          Navigator.pop(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.white.withOpacity(0.3),
                      child: Center(
                        child: Text(
                          "C'est Parti!",
                          style: GoogleFonts.comicNeue(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
