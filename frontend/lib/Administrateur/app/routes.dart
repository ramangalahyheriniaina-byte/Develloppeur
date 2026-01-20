import 'package:flutter/material.dart';
import 'package:frontend/auth/view/login.dart';
import '../layout/main_layout.dart';

// ===============================
/// NOMS DES ROUTES (App globale)
// ===============================
class AppRoutes {
  //Authentification
  static const String login = '/login';
  static const String logout = '/logout';

  //Admin (Layout unique)
  static const String admin = '/admin';

  // Prof (à venir)
  static const String profHome = '/prof/home';

  //  Étudiant (à venir)
  static const String etudiantHome = '/etudiant/home';
}

// ===============================
/// ROUTER CENTRAL (Navigation globale)
// ===============================
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

    // =====================
    /// AUTH
    // =====================
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

    // =====================
    /// ADMIN (layout unique)
    // =====================
      case AppRoutes.admin:
        return MaterialPageRoute(
          builder: (_) => const MainLayout(), // MainLayout décide quelle page afficher
        );

    // =====================
    /// LOGOUT
    // =====================
      case AppRoutes.logout:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

    // =====================
    /// DEFAULT
    // =====================
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Error -> Route non trouvée'),
            ),
          ),
        );
    }
  }
}

// ===============================
/// Routes internes au MainLayout (ADMIN)
// ===============================
class Routes {
  // Page par défaut (cours)
  static const String cours = 'cours';

  // Emploi du temps
  static const String programme = 'edt';

  // Dashboard
  static const String dashboard = 'dashboard';
}

