import 'package:flutter/material.dart';
import 'package:apk_web_eduflow/auth/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF5B9BB0),
        child: Stack(
          children: [

            // ========= CERCLE BAS GAUCHE =========
            Positioned(
              left: -140,
              bottom: -140,
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              left: -80,
              bottom: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ========= CERCLE HAUT DROIT =========
            Positioned(
              top: -110,
              right: -110,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: 60,
              right: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ========= CONTENU =========
            Center(
              child: Transform.translate(
                offset: const Offset(0, -50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          "EduFlow",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ===== LOGO =====
                    Image.asset(
                      'assets/images/logo.png',
                      width: 90,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 50),

                    // ===== FORM LOGIN (fonctionnalité conservée) =====
                    const SizedBox(
                      width: 300,
                      child: LoginForm(),
                    ),
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
