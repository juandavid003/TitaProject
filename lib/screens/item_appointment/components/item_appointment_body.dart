import 'package:flutter/material.dart';

class ItemAppointmentBody extends StatefulWidget {
  const ItemAppointmentBody({super.key});

  @override
  _ItemAppointmentBodyState createState() => _ItemAppointmentBodyState();
}

class _ItemAppointmentBodyState extends State<ItemAppointmentBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Fondo semi-transparente
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3), // Casi transparente
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            "Pantalla Transparente",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
