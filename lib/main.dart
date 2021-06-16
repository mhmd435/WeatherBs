import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Homepage(),
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my App"),
        backgroundColor: Colors.grey[900],
        elevation: 20,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Text(
                "Mountain View",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "clear sky",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(
                Icons.light_mode_outlined,
                color: Colors.white,
                size: 60,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "14^",
                style: TextStyle(fontSize: 50, color: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "max",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "16^",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Container(
                      color: Colors.grey,
                      width: 2,
                      height: 40,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "min",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "12^",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                color: Colors.white24,
                height: 2,
                width: double.infinity,
              ),
            ),
            Row(
              children: [
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,position) {
                      return daysWeatherView();
                    }),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Card daysWeatherView(){
    return Card(
      elevation: 10,
      child: Container(
          width: 20,
          height: 50,
          child: Text("mhmd",style: TextStyle(fontSize: 16, color: Colors.white))),
    );
  }
}
