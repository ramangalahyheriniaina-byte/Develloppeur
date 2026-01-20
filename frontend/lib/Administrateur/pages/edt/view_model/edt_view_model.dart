// lib/features/edt/view_model/edt_view_model.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'dart:convert'; //  Décommenter pour le backend
// import 'package:http/http.dart' as http; //  Décommenter pour le backend
import '../../../core/navigation_view_model.dart';
import '../../cours/models/cours_model.dart';
import '../models/edtModel.dart';

class EdtViewModel extends ChangeNotifier {
  String selectedNiveau = "L1";
  String selectedJour = "Lundi";
  DateTime selectedWeekStart = _currentWeekMonday();
  Cours? selectedCours;

  final List<Edt> _edtList = [];

  // 🔌 Configuration backend
  // static const String baseUrl = "https://api.eduflow.com"; // Remplacer par ton URL

  /// Récupérer lundi de la semaine courante
  static DateTime _currentWeekMonday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - (now.weekday - 1));
  }

  /// Changer le niveau
  void changerNiveau(String niveau) {
    selectedNiveau = niveau;
    selectedCours = null;
    notifyListeners();
  }

  /// Changer le jour
  void changerJour(String jour) {
    selectedJour = jour;
    notifyListeners();
  }

  /// Changer la semaine
  void changerSemaine(DateTime monday) {
    selectedWeekStart = monday;
    notifyListeners();
  }

  /// Sélectionner un cours
  void selectionnerCours(Cours cours) {
    selectedCours = cours;
    notifyListeners();
  }

  /// 🔌 CHARGER TOUS LES EDT DEPUIS LE BACKEND (à appeler au démarrage)
  Future<void> chargerEdtDepuisBackend() async {
    try {
      // 🔌 BACK : GET tous les EDT
      /*
      final response = await http.get(
        Uri.parse("$baseUrl/edt"),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token", // Si authentification
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _edtList.clear();
        _edtList.addAll(data.map((json) => Edt.fromJson(json)).toList());
        notifyListeners();
      } else {
        print("Erreur chargement EDT: ${response.statusCode}");
      }
      */

      // 🧪 MOCK LOCAL (à supprimer quand le backend est prêt)
      print("📥 Chargement EDT depuis le backend...");

    } catch (e) {
      print("❌ Erreur réseau: $e");
    }
  }

  /// 🔌 AJOUTER UN EDT
  Future<void> ajouterEdt(
      BuildContext context, {
        required String heureDebut,
        required String heureFin,
      }) async {
    if (selectedCours == null) return;

    final edt = Edt(
      niveau: selectedNiveau,
      weekStart: selectedWeekStart,
      jour: selectedJour,
      matiere: selectedCours!.matiere,
      professeur: selectedCours!.professeur,
      heureDebut: heureDebut,
      heureFin: heureFin,
    );

    try {
      // 🔌 BACK : POST créer un EDT
      /*
      final response = await http.post(
        Uri.parse("$baseUrl/edt"),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token",
        },
        body: jsonEncode(edt.toJson()),
      );

      if (response.statusCode == 201) {
        // Récupérer l'EDT créé avec son ID depuis le backend
        final edtCree = Edt.fromJson(jsonDecode(response.body));
        _edtList.add(edtCree);

        print("✅ EDT créé avec ID: ${edtCree.id}");
      } else {
        print("❌ Erreur création EDT: ${response.statusCode}");
        return;
      }
      */

      // 🧪 MOCK LOCAL (à supprimer quand le backend est prêt)
      _edtList.add(edt);
      print("✅ EDT ajouté localement");

      final edtExiste = _edtList.isNotEmpty;
      context.read<NavigationViewModel>().markEdtExists(edtExiste);
      context.read<NavigationViewModel>().markDashboardEnabled(edtExiste);

      notifyListeners();

    } catch (e) {
      print("❌ Erreur ajout EDT: $e");
    }
  }

  /// 🔌 MODIFIER LE STATUT D'UN COURS
  Future<void> modifierStatutCours(
      Edt edt, {
        bool? termine,
        bool? enRetard,
        bool? annule,
      }) async {
    final index = _edtList.indexOf(edt);
    if (index == -1) return;

    // Mise à jour locale
    if (termine != null) _edtList[index].termine = termine;
    if (enRetard != null) _edtList[index].enRetard = enRetard;
    if (annule != null) _edtList[index].annule = annule;

    try {
      // 🔌 BACK : PATCH modifier un EDT
      /*
      if (edt.id != null) {
        final response = await http.patch(
          Uri.parse("$baseUrl/edt/${edt.id}"),
          headers: {
            "Content-Type": "application/json",
            // "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            if (termine != null) "termine": termine,
            if (enRetard != null) "en_retard": enRetard,
            if (annule != null) "annule": annule,
          }),
        );

        if (response.statusCode == 200) {
          print("✅ Statut EDT modifié");
        } else {
          print("❌ Erreur modification: ${response.statusCode}");
        }
      }
      */

      // 🧪 MOCK LOCAL
      print("✅ Statut modifié localement");

    } catch (e) {
      print("❌ Erreur modification statut: $e");
    }

    notifyListeners();
  }

  /// 🔌 SUPPRIMER UN EDT
  Future<void> supprimerEdt(Edt edt) async {
    try {
      // 🔌 BACK : DELETE supprimer un EDT
      /*
      if (edt.id != null) {
        final response = await http.delete(
          Uri.parse("$baseUrl/edt/${edt.id}"),
          headers: {
            "Content-Type": "application/json",
            // "Authorization": "Bearer $token",
          },
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          _edtList.remove(edt);
          print("✅ EDT supprimé");
        } else {
          print("❌ Erreur suppression: ${response.statusCode}");
          return;
        }
      }
      */

      // 🧪 MOCK LOCAL
      _edtList.remove(edt);
      print("✅ EDT supprimé localement");

    } catch (e) {
      print("❌ Erreur suppression EDT: $e");
    }

    notifyListeners();
  }

  /// EDT du jour sélectionné (pour EdtView)
  List<Edt> edtCourant() {
    return _edtList.where((e) =>
    e.niveau == selectedNiveau &&
        _isSameWeek(e.weekStart, selectedWeekStart) &&
        e.jour == selectedJour
    ).toList();
  }

  /// EDT de la semaine complète
  List<Edt> edtSemaineComplete() {
    return _edtList.where((e) =>
    e.niveau == selectedNiveau &&
        _isSameWeek(e.weekStart, selectedWeekStart)
    ).toList();
  }

  /// Tous les EDT (pour le Dashboard)
  List<Edt> tousLesEdt() {
    return List.unmodifiable(_edtList);
  }

  /// EDT de la semaine actuelle
  List<Edt> edtSemaineActuelle() {
    final lundiActuel = _currentWeekMonday();
    return _edtList.where((e) =>
        _isSameWeek(e.weekStart, lundiActuel)
    ).toList();
  }

  /// EDT d'aujourd'hui
  List<Edt> edtAujourdhui() {
    return _edtList.where((e) => e.estAujourdhui).toList();
  }

  /// Dashboard activable ?
  bool get dashboardActivable => _edtList.isNotEmpty;

  /// Y a-t-il des cours aujourd'hui ?
  bool get aCourssAujourdhui => edtAujourdhui().isNotEmpty;

  /// Comparer deux semaines
  bool _isSameWeek(DateTime date1, DateTime date2) {
    final monday1 = DateTime(date1.year, date1.month, date1.day - (date1.weekday - 1));
    final monday2 = DateTime(date2.year, date2.month, date2.day - (date2.weekday - 1));

    return monday1.year == monday2.year &&
        monday1.month == monday2.month &&
        monday1.day == monday2.day;
  }
}