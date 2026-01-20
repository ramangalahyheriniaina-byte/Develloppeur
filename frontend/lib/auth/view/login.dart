import 'package:flutter/material.dart';
import 'package:frontend/auth/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF6FA6BC),
        child: Stack(
          children: [
            // cercle gauche bas
            Positioned(
              left: -120,
              bottom: -120,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // cercle droit haut
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Center(
              child: Transform.translate(
                offset: const Offset(0, -65),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "EduFlow",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Image.asset(
                      'lib/assets/images/logo.png',
                      width: 168,
                      height: 171,
                    ),

                    const SizedBox(height: 30),

                    const LoginForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
