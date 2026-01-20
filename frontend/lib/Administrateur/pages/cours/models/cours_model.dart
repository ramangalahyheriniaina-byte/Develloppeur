class Cours {
  String niveau;
  String matiere;
  String professeur;
  int heuresTotales;

  Cours({
    required this.niveau,
    required this.matiere,
    required this.professeur,
    required this.heuresTotales,
  });

  // Exemple JSON pour envoi au back
  Map<String, dynamic> toJson() => {
    'niveau': niveau,
    'matiere': matiere,
    'prof': professeur,
    'heures_totales': heuresTotales,
  };
}
