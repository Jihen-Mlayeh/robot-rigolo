import 'package:flutter/material.dart';

class ChoiceExPage extends StatelessWidget {
  final List<Map<String, String>> exercises = [
    {'title': 'Addition', 'image': 'assets/images/addition.png'},
    {'title': 'Soustraction', 'image': 'assets/images/substract.png'},
    {'title': 'Multiplication', 'image': 'assets/images/multiply.png'},
    {'title': 'Division', 'image': 'assets/images/divide.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez votre exercice'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        // Ajoutez une action à effectuer lorsqu'un exercice est sélectionné
                        print('Exercice sélectionné : ${exercises[index]['title']}');
                      },
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Colors.orange.shade300, Colors.orange.shade500],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                exercises[index]['image']!,
                                height: 80,
                                width: 80,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 10),
                              Text(
                                exercises[index]['title']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}