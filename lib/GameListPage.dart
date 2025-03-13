import 'package:calculs/CalculSimplePage.dart';
import 'package:flutter/material.dart';

class GameListPage extends StatelessWidget {
  const GameListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Couleurs principales (exemple)
    final Color backgroundColor = const Color(0xFFFFD06F);
    final Color cardColor = const Color(0xFFFFC232);
    final Color transparentColor = Colors.transparent;
    final Color gameContainerColor = Color(0xFF74F1F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: Stack(
              children: [

                Image.asset(
                  'assets/images/QT/QT_speak.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                ),

                Column(
                  children: [

                    Container(
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Mini-jeux',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),

                    ),

                    const SizedBox(height: 60),


                    GameContainer(color: gameContainerColor, cardColor: cardColor)
                    ,
                  ],
                )
              ],
            )

            ,
          ),
        ),
      ),
    );
  }
}

class GameContainer extends StatelessWidget {

  final Color color;
  final Color cardColor;


  const GameContainer({
    Key? key,


    required this.color,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,

        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Year'),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Month'),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Today'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- Cartes ou sections pour chaque statistique ---
          _StatCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalculSimplePage()));
            },
            color: cardColor,
            icon: Icons.local_drink,
            title: 'Calculs simples',
            subtitle: '2 + 2 = ?',
            iconColor: Colors.blueAccent,
          ),
          const SizedBox(height: 16),
          _StatCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalculSimplePage()));
            },
            color: cardColor,
            icon: Icons.apple,
            title: 'Retrouve le symbole',
            subtitle: '2 _ 3 = 6',
            iconColor: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          _StatCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalculSimplePage()));
            },
            color: cardColor,
            icon: Icons.directions_walk,
            title: 'Walk',
            subtitle: '21h/week',
            iconColor: Colors.green,
          ),
          const SizedBox(height: 16),
          _StatCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalculSimplePage()));
            },
            color: cardColor,
            icon: Icons.bedtime,
            title: 'Sleep',
            subtitle: '21h/week',
            iconColor: Colors.deepPurpleAccent,
          ),
          const SizedBox(height: 16),
          _StatCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalculSimplePage()));
            },
            color: cardColor,
            icon: Icons.bedtime,
            title: 'Sleep',
            subtitle: '21h/week',
            iconColor: Colors.deepPurpleAccent,
          ),
          const SizedBox(height: 16),
          _StatCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CalculSimplePage()));
            },
            color: cardColor,
            icon: Icons.bedtime,
            title: 'Sleep',
            subtitle: '21h/week',
            iconColor: Colors.deepPurpleAccent,
          )
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
      onTap: (){
        onTap();
      },
      child:  Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icône
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
            // Titre et sous-titre
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