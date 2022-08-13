import 'package:flutter/material.dart';
import 'package:yourdeviceinfo/Homepage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
 Future<Widget> waitinglogo =
      Future<Widget>.delayed(Duration(seconds: 2), ()=>HomePage(),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: waitinglogo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
           return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/androidbackground.jpg",
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken,
                  color: Color.fromARGB(255, 223, 192, 55),
                ),
              ],
            );
        },
      )),
    );
  }
 
}
