import 'package:calculs/CalculSimpleTimerPage.dart';
import 'package:flutter/material.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({Key? key}) : super(key: key);

  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  bool timerEnabled = false;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFFFD06F);
    final Color cardColor = const Color(0xFFFFC232);
    final Color gameContainerColor = const Color(0xFF74F1F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
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
                  )





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
        borderRadius: BorderRadius.only(
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
                activeColor: Colors.green, // vous pouvez ajuster la couleur pour correspondre à votre design
              ),
            ],
          ),
          const SizedBox(height: 16),
          // La liste des cartes s'adapte et défile si nécessaire
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalculSimpleTimerPage(
                          timerEnabled: timerEnabled,
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.local_drink,
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
                        builder: (context) => CalculSimpleTimerPage(
                          timerEnabled: timerEnabled,
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.apple,
                  title: 'Retrouve le symbole',
                  subtitle: '2 _ 3 = 6',
                  iconColor: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalculSimpleTimerPage(
                          timerEnabled: timerEnabled,
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.directions_walk,
                  title: 'Jeu 3',
                  subtitle: '2 + 2 = ?',
                  iconColor: Colors.green,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalculSimpleTimerPage(
                          timerEnabled: timerEnabled,
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.bedtime,
                  title: 'Jeu 4',
                  subtitle: 'description',
                  iconColor: Colors.deepPurpleAccent,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalculSimpleTimerPage(
                          timerEnabled: timerEnabled,
                        ),
                      ),
                    );
                  },
                  color: cardColor,
                  icon: Icons.bedtime,
                  title: 'Jeu 5',
                  subtitle: 'description',
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
