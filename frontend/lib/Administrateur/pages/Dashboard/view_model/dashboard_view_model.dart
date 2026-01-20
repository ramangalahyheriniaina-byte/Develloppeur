//  lib/features/dashboard/view_model/dashboard_view_model.dart
import 'package:flutter/material.dart';
import '../../edt/models/edtModel.dart';
import '../models/dashboard_model.dart';

class DashboardViewModel extends ChangeNotifier {
  List<Edt> _edtList = [];
  String selectedNiveau = "L1";

  DashboardViewModel();

  void updateEdtList(List<Edt> edtList) {
    _edtList = edtList;
    notifyListeners();
  }

  void changerNiveau(String niveau) {
    selectedNiveau = niveau;
    notifyListeners();
  }

  /// UNIQUEMENT les cours EN COURS actuellement (pas à venir, pas terminés)
  List<DashboardModel> dashboardCours() {
    return _edtList
        .where((e) =>
    e.niveau == selectedNiveau &&
        e.estAujourdhui &&
        e.statutActuel == "En cours" // FILTRE : seulement "En cours"
    )
        .map((e) => DashboardModel.fromEdt(e))
        .toList();
  }

  /// Tous les cours EN COURS (tous niveaux)
  List<DashboardModel> tousLesCoursEnCours() {
    return _edtList
        .where((e) =>
    e.estAujourdhui &&
        e.statutActuel == "En cours"
    )
        .map((e) => DashboardModel.fromEdt(e))
        .toList();
  }

  /// Statistiques des cours EN COURS aujourd'hui
  Map<String, int> statistiquesDuJour() {
    final coursEnCours = tousLesCoursEnCours();

    return {
      'total': coursEnCours.length,
      'enRetard': coursEnCours.where((c) => c.edt.enRetard).length,
      'annules': coursEnCours.where((c) => c.edt.annule).length,
    };
  }

  /// Actions
  Future<void> annulerCours(DashboardModel dm) async {
    dm.edt.annule = true;

    // BACK : PATCH
    /*
    if (dm.edt.id != null) {
      final response = await http.patch(
        Uri.parse("$baseUrl/edt/${dm.edt.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"annule": true}),
      );
      if (response.statusCode != 200) {
        dm.edt.annule = false; // Rollback
      }
    }
    */

    print("Cours annulé localement");
    notifyListeners();
  }

  Future<void> marquerEnRetard(DashboardModel dm) async {
    dm.edt.enRetard = true;

    // 🔌 BACK : PATCH
    /*
    if (dm.edt.id != null) {
      final response = await http.patch(
        Uri.parse("$baseUrl/edt/${dm.edt.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"en_retard": true}),
      );
      if (response.statusCode != 200) {
        dm.edt.enRetard = false; // Rollback
      }
    }
    */

    print("Cours marqué en retard localement");
    notifyListeners();
  }

  /// Y a-t-il des cours EN COURS ?
  bool get aCoursEnCours => _edtList.any((e) =>
  e.estAujourdhui &&
      e.statutActuel == "En cours"
  );

  String get jourActuel {
    const jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];
    return jours[DateTime.now().weekday - 1];
  }
}