import 'package:facebook/screens/problem_screen.dart';
import 'package:flutter/material.dart';

import '../Chat/chat_screen.dart';

class GetHelp extends StatelessWidget {
  static const String routeName = 'get help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffF8CAE4),
        centerTitle: true,
        title: Text(
          "Get Help",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Stack(children: [
        // Image.asset(
        //   "assets/images/photo_58.jpg",
        //   height: 757,
        //   fit: BoxFit.fill,
        // ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 220, left: 30),
              child: Text(
                "Is there any problem",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7, left: 30),
              child: Text(
                "Or a complaint you want to report?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8, left: 40),
              child: MaterialButton(
                elevation: 5.0,
                color: Color(0xffF8CAE4),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(ProblemScreen.routeName);
                },
                child: const Text(
                  'Report a problem',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7, left: 30),
              child: Text(
                "Contact Us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8, left: 40),
              child: MaterialButton(
                  elevation: 5.0,
                  color: Color(0xffF8CAE4),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ChatScreen.routeName);
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    weight: 60,
                  )),
            ),
          ],
        )
      ]),
    );
  }
}
