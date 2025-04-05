import 'dart:math';
import 'package:calculs/BullesMagiquesPage.dart';
import 'package:calculs/EducatedMonkeyPage.dart';
import 'package:calculs/ExerciceTemplate.dart';
import 'package:flutter/material.dart';
import 'TableDeMultiplication.dart';

class GameListPageDifficile extends StatefulWidget {
  const GameListPageDifficile({Key? key}) : super(key: key);

  @override
  _GameListPageDifficileState createState() => _GameListPageDifficileState();
}

class _GameListPageDifficileState extends State<GameListPageDifficile> {
  bool timerEnabled = false;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFFFD06F);
    final Color cardColor = const Color(0xFFFFC232);
    final Color gameContainerColor = const Color(0xFF74F1F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        // On utilise un Stack pour superposer le contenu principal et l'overlay des objets volants
        child: Stack(
          children: [
            Column(
              children: [
                // En-tête avec les images et le titre
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
                                image: AssetImage('assets/images/QT/emotions/langue.png'),
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 10),
                          child: Text(
                            'Mini-jeux',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // GameContainer occupe le reste de l'espace
                Expanded(
                  child: GameContainer(
                    color: gameContainerColor,
                    cardColor: cardColor,
                    timerEnabled: timerEnabled,
                    onTimerChanged: (bool value) {
                      setState(() {
                        timerEnabled = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            // Overlay des objets volants
            FlyingItemsOverlay(),
          ],
        ),
      ),
    );
  }
}

class GameContainer extends StatelessWidget {
  final Color color;
  final Color cardColor;
  final bool timerEnabled;
  final ValueChanged<bool> onTimerChanged;

  const GameContainer({
    Key? key,
    required this.color,
    required this.cardColor,
    required this.timerEnabled,
    required this.onTimerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne contenant le libellé et le switch
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Chronomètre",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch.adaptive(
                value: timerEnabled,
                onChanged: onTimerChanged,
                activeColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // La liste des cartes défilante
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciceTemplate(
                          timerEnabled: timerEnabled,
                          exerciceFile: 'assets/questions/simple_calcul.json',
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.calculate,
                  title: 'Calculs simples',
                  subtitle: '2 + 2 = ?',
                  iconColor: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BullesMagiquesPage(

                          )
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.calculate,
                  title: 'Bulles magiques',
                  subtitle: 'Calculs simples dans un format\n rigolo !',
                  iconColor: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciceTemplate(
                          timerEnabled: timerEnabled,
                          exerciceFile: 'assets/questions/calcul_parentheses.json',
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.calculate,
                  title: 'Priorité opératoire',
                  subtitle: '(3 + 5) × 2 = ?',
                  iconColor: Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciceTemplate(
                          timerEnabled: timerEnabled,
                          exerciceFile: 'assets/questions/complete_suite_difficile.json',
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.list_alt,
                  title: "Complete la suite !",
                  subtitle: '1, 2, 3, ?, 5',
                  iconColor: Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciceTemplate(
                          timerEnabled: timerEnabled,
                          exerciceFile: 'assets/questions/trouve_intrus_difficile.json',
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.search,
                  title: "Trouve l'intrus !",
                  subtitle: '1, 2, 3, 4, 5, 6, 19, 8, 9',
                  iconColor: Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableDeMultiplication(
                          timerEnabled: timerEnabled,
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.crop_square_sharp,
                  title: 'Table De Multiplication',
                  subtitle: '1*4=?',
                  iconColor: Colors.deepPurpleAccent,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _StatCard({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 75,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
//              Objets volants avec explosion
// ======================================================================

class FlyingItemsOverlay extends StatefulWidget {
  @override
  _FlyingItemsOverlayState createState() => _FlyingItemsOverlayState();
}

class _FlyingItemsOverlayState extends State<FlyingItemsOverlay> {
  final int itemCount = 4; // Nombre d'objets volants

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(itemCount, (index) => FlyingItem(key: UniqueKey())),
    );
  }
}

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
      // Définition de positions aléatoires de départ et d'arrivée
      startX = random.nextDouble() * (size.width - 50);
      startY = random.nextDouble() * (size.height - 50);
      endX = random.nextDouble() * (size.width - 50);
      endY = random.nextDouble() * (size.height - 50);
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 5 + random.nextInt(3)), // Durée entre 5 et 7 secondes
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
      Future.delayed(const Duration(milliseconds: 500), () {
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
                : Image.asset('assets/images/other/fly22.png', width: 80, height: 80),
          ),
        );
      },
    );
  }
}
