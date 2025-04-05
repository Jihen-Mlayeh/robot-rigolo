import 'dart:math';
import 'package:calculs/GameListPageDifficile.dart';
import 'package:calculs/GameListPageFacile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultySelectionPage extends StatelessWidget {
  final int age; // Âge sélectionné passé en paramètre

  DifficultySelectionPage({required this.age});

  // Ta palette de couleurs
  final Color backgroundColor = const Color(0xFFFFD06F);
  final Color cardColor = const Color(0xFFFFC232);
  final Color gameContainerColor = const Color(0xFF74F1F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        // On utilise un Stack pour superposer le contenu principal et l'overlay de papillons
        child: Stack(
          children: [
            // Contenu principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                children: [
                  // Titre d'introduction
                  Text(
                    "Tu as $age ans,\n choisi ton chemin !",
                    style: GoogleFonts.comicNeue(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  // Affichage des cartes de difficulté
                  if (age >= 8)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildCard(
                            context,
                            title: "Facile",
                            imagePath: 'assets/images/other/oupi_goupy.png',
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameListPageFacile(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildCard(
                            context,
                            title: "Difficile",
                            imagePath: 'assets/images/other/larryb.png',
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameListPageDifficile(),
                                ),
                              );

                            },
                          ),
                        ),
                      ],
                    )
                  else
                  // Carte d'erreur si l'âge est insuffisant
                    _buildCard(
                      context,
                      title: "Erreur",
                      icon: Icons.error,
                      onTap: () {},
                    ),
                  const SizedBox(height: 50),
                  // Partie décorative avec image et texte
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              const Positioned(
                                top: 20,
                                left: 50,
                                child: Image(
                                  image: AssetImage('assets/images/QT/emotions/cute.png'),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                          // Texte qui s'adapte à l'espace restant
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20, bottom: 10),
                              child: Text(
                                "Amuse-toi bien !",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  // Petite bordure décorative en bas de page
                  Container(
                    height: 5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: gameContainerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            // Overlay des petits objets qui volent
            FlyingItemsOverlay(),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire une carte de niveau
  Widget _buildCard(BuildContext context,
      {required String title,
        IconData? icon,
        String? imagePath,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cercle décoratif contenant l'image (ou l'icône si imagePath est null)
            Container(
              decoration: BoxDecoration(
                color: gameContainerColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(20),
              child: imagePath != null
                  ? Image.asset(
                imagePath,
                width: 50,
                height: 50,
              )
                  : Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.comicNeue(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Overlay qui affiche plusieurs FlyingItem dans un Stack
class FlyingItemsOverlay extends StatefulWidget {
  @override
  _FlyingItemsOverlayState createState() => _FlyingItemsOverlayState();
}

class _FlyingItemsOverlayState extends State<FlyingItemsOverlay> {
  final int itemCount = 4; // nombre d'objets volants

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(itemCount, (index) => FlyingItem(key: UniqueKey())),
    );
  }
}

// Widget représentant un petit objet volant qui réagit au clic
class FlyingItem extends StatefulWidget {
  const FlyingItem({Key? key}) : super(key: key);

  @override
  _FlyingItemState createState() => _FlyingItemState();
}

class _FlyingItemState extends State<FlyingItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool exploded = false;
  double startX = 0, startY = 0, endX = 0, endY = 0;
  final random = Random();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      // Définir des positions de départ et d'arrivée aléatoires
      startX = random.nextDouble() * (size.width - 50);
      startY = random.nextDouble() * (size.height - 50);
      endX = random.nextDouble() * (size.width - 50);
      endY = random.nextDouble() * (size.height - 50);
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 5 + random.nextInt(3)), // entre 5 et 7 secondes
      );
      _animation = Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(endX, endY),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          final size = MediaQuery.of(context).size;
          startX = random.nextDouble() * (size.width - 50);
          startY = random.nextDouble() * (size.height - 50);
          endX = random.nextDouble() * (size.width - 50);
          endY = random.nextDouble() * (size.height - 50);
          _animation = Tween<Offset>(
            begin: Offset(startX, startY),
            end: Offset(endX, endY),
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
          _controller.reset();
          _controller.forward();
        }
      });
      _controller.forward();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!exploded) {
      setState(() {
        exploded = true;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          exploded = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _animation.value.dx,
          top: _animation.value.dy,
          child: GestureDetector(
            onTap: _onTap,
            child: exploded
                ? Image.asset('assets/images/other/celebration.png', width: 80, height: 80)
                : Image.asset('assets/images/other/fly11.png', width: 80, height: 80),
          ),
        );
      },
    );
  }
}
