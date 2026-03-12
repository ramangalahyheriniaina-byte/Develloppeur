import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour SystemMouseCursors

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF629EB9),
      body: Stack(
        children: [
          // Forme organique blanche à gauche
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: ClipPath(
              clipper: SoftOrganicShapeClipper(),
              child: Container(
                width: size.width * 0.55,
                color: Colors.white,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  // ================= LEFT SIDE (IMAGE) =================
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: const Alignment(-0.2, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Image.asset(
                          "assets/images/acceuil.png",
                          height: size.height * 0.65,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // ================= RIGHT SIDE (TEXT) =================
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITRE (en haut)
                          const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              "EduFlow",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          /// Contenu centré (slogan, description, bouton)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// SLOGAN
                                const Text(
                                  "Pour une éducation\nplus efficace.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// DESCRIPTION
                                const Text(
                                  "EduFlow utilise l'IA pour générer automatiquement\nles programmes scolaires.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 40),

                                /// BOUTON COMMENCER (avec hover)
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_) => setState(() => _isHovered = true),
                                  onExit: (_) => setState(() => _isHovered = false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    width: _isHovered ? 250 : 240,
                                    height: _isHovered ? 62 : 58,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFA6C0D6),
                                          Color(0xFFF8FAFC),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.1),
                                          blurRadius: _isHovered ? 20 : 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/',
                                                (route) => false,
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Commencer",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: _isHovered ? 19 : 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.black,
                                                size: _isHovered ? 24 : 22,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SoftOrganicShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.7, 0);

    path.cubicTo(
        size.width * 0.85,
        size.height * 0.15,
        size.width * 0.8,
        size.height * 0.3,
        size.width * 0.7,
        size.height * 0.4);

    path.cubicTo(
        size.width * 0.6,
        size.height * 0.5,
        size.width * 0.65,
        size.height * 0.7,
        size.width * 0.75,
        size.height * 0.8);

    path.cubicTo(
        size.width * 0.85,
        size.height * 0.9,
        size.width * 0.8,
        size.height * 0.95,
        size.width * 0.9,
        size.height);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}