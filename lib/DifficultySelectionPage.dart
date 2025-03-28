import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultySelectionPage extends StatelessWidget {
  final int age;  // Âge sélectionné passé en paramètre

  DifficultySelectionPage({required this.age});

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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20), // Ajouter un peu de marge pour éviter le débordement
                child: Text(
                  "Tu as $age ans,\n donc voici les niveaux disponibles !",  // Ajouter le saut de ligne ici
                  style: GoogleFonts.comicNeue(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center, // Centrer le texte
                  maxLines: 2, // Limiter à 2 lignes
                  overflow: TextOverflow.ellipsis, // Ajouter des points de suspension si le texte dépasse
                ),
              ),
              SizedBox(height: 40),

              // Conditionner l'affichage des niveaux de difficulté en fonction de l'âge
              if (age >= 8) ...[
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Facile", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Moyen", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Difficile", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ] else if (age >= 6) ...[
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Facile", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Moyen", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Facile", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
