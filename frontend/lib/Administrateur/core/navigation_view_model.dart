import 'package:flutter/material.dart';

class NavigationViewModel extends ChangeNotifier {
  String _currentRoute = '/cours';
  bool _coursExists = false;
  bool _edtExists = false;

  String get currentRoute => _currentRoute;
  bool get dashboardEnabled => _coursExists && _edtExists;

  void setCurrentRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  //  Notifie qu'il y a au moins un cours
  void markCoursExists(bool exists) {
    _coursExists = exists;
    notifyListeners();
  }

  //  Notifie qu'il y a au moins un EDT
  void markEdtExists(bool exists) {
    _edtExists = exists;
    notifyListeners();
  }

  // Optionnel : méthode directe pour Dashboard si tu veux l’appeler
  void markDashboardEnabled(bool enabled) {
    _edtExists = enabled;
    notifyListeners();
  }
}
