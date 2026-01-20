import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation_view_model.dart';
import '../models/cours_model.dart';

class CoursViewModel extends ChangeNotifier {
  String selectedNiveau = 'L1';
  final List<Cours> _coursList = [];

  List<Cours> get coursList => _coursList;

  // Ajouter un cours
  void ajouterCours(String matiere, String professeur, int heures, BuildContext context) {
    final nouveauCours = Cours(
      niveau: selectedNiveau,
      matiere: matiere,
      professeur: professeur,
      heuresTotales: heures,
    );

    _coursList.add(nouveauCours);

    // ⚡ Notifie NavigationViewModel qu’il y a maintenant au moins un cours
    context.read<NavigationViewModel>().markCoursExists(_coursList.isNotEmpty);

    notifyListeners();
  }

  // Supprimer un cours
  void supprimerCours(Cours cours, BuildContext context) {
    _coursList.remove(cours);

    //  Met à jour NavigationViewModel si aucun cours n'existe plus
    context.read<NavigationViewModel>().markCoursExists(_coursList.isNotEmpty);

    notifyListeners();
  }

  // Changer de niveau
  void changerNiveau(String niveau) {
    selectedNiveau = niveau;
    notifyListeners();
  }

  // Heures totales pour le niveau sélectionné
  int get totalHeures => _coursList
      .where((c) => c.niveau == selectedNiveau)
      .fold(0, (sum, c) => sum + c.heuresTotales);

  // Nombre de cours pour le niveau sélectionné
  int get totalCours => _coursList.where((c) => c.niveau == selectedNiveau).length;
}