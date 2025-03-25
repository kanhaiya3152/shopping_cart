import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 154, 180),
        title: Text("Catalogue"),
        centerTitle: true,
        actions: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 30,
          )
        ],
      ),
      body: Container(),
    );
  }
}