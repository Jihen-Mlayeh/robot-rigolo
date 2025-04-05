import 'package:flutter/material.dart';

class EducatedMonkeyPage extends StatefulWidget {
  const EducatedMonkeyPage({Key? key}) : super(key: key);

  @override
  _EducatedMonkeyPageState createState() => _EducatedMonkeyPageState();
}

class _EducatedMonkeyPageState extends State<EducatedMonkeyPage> {
  // Valeurs sélectionnées pour chaque patte (entre 1 et 12)
  double _leftOperand = 1;
  double _rightOperand = 1;

  @override
  Widget build(BuildContext context) {
    // Calcul du produit
    int product = (_leftOperand * _rightOperand).toInt();

    return Scaffold(
      body: 
    Container(
        width: double.infinity,
        height: double.infinity,
        // On peut ajouter un dégradé pour un design plus sympathique
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Corps du singe
              Positioned.fill(
                child: Image.asset(
                  'assets/images/other/star.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Curseur pour la patte de gauche
              Positioned(
                // Ajustez la position selon vos besoins
                bottom: 40,
                left: 30,
                child: Column(
                  children: [
                    Text(
                      '${_leftOperand.toInt()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Slider(
                        value: _leftOperand,
                        min: 1,
                        max: 12,
                        divisions: 11, // divisions entre 1 et 12
                        activeColor: Colors.brown,
                        inactiveColor: Colors.brown.shade200,
                        onChanged: (value) {
                          setState(() {
                            _leftOperand = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Curseur pour la patte de droite
              Positioned(
                // Ajustez la position selon vos besoins
                bottom: 40,
                right: 30,
                child: Column(
                  children: [
                    Text(
                      '${_rightOperand.toInt()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Slider(
                        value: _rightOperand,
                        min: 1,
                        max: 12,
                        divisions: 11,
                        activeColor: Colors.brown,
                        inactiveColor: Colors.brown.shade200,
                        onChanged: (value) {
                          setState(() {
                            _rightOperand = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Zone centrale (les mains du singe) qui affiche le produit
              Positioned(
                // Centré, on peut ajuster la hauteur si besoin
                top: MediaQuery.of(context).size.height * 0.4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.brown, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '$product',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
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
