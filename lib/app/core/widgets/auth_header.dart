import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 150),

        // Logo Litera
        Container(
          width: 250,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // woman reading image
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/images/woman_reading.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 48),
      ],
    );
  }
}
