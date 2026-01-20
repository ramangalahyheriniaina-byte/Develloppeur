import 'package:flutter/material.dart';

import '../models/login_response.dart';
import '../services/auth_service.dart';
import 'package:frontend/Administrateur/app/routes.dart';

/// ===============================
/// LoginViewModel
/// - appell le backend
/// - gère le loading / erreur
/// - stocke la reponse login
/// - redirige selon le rôle
/// ===============================
class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  LoginResponse? loginResponse;

  /// LOGIN PRINCIPAL
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      //////////////////// Appel backend
      loginResponse = await _authService.login(
        email: email,
        password: password,
      );

      // Vérification sécurité
      if (loginResponse == null || loginResponse!.user == null) {
        throw Exception("Réponse login invalide");
      }

      final user = loginResponse!.user!;
      final role = user.role;

      // REDIRECTION SELON ROLE
      if (role == 'admin') {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.admin, // <-- corrigé
        );
      } else if (role == 'prof') {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.profHome,
        );
      } else if (role == 'etudiant') {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.etudiantHome,
        );
      } else {
        throw Exception("Rôle utilisateur inconnu");
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


