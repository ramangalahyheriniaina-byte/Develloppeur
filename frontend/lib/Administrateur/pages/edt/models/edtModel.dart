class Edt {
  final String niveau;
  final DateTime weekStart; // ✅ Semaine de référence (Lundi)
  final String jour;
  final String matiere;
  final String professeur;
  final String heureDebut;
  final String heureFin;
  bool termine;   // Statut cours terminé
  bool enRetard;  // Statut cours en retard
  bool annule;    // Statut cours annulé

  Edt({
    required this.niveau,
    required this.weekStart,
    required this.jour,
    required this.matiere,
    required this.professeur,
    required this.heureDebut,
    required this.heureFin,
    this.termine = false,
    this.enRetard = false,
    this.annule = false,
  });

  /// 🆕 Convertir en JSON (pour backend)
  Map<String, dynamic> toJson() => {
    "niveau": niveau,
    "week_start": weekStart.toIso8601String(),
    "jour": jour,
    "matiere": matiere,
    "professeur": professeur,
    "heure_debut": heureDebut,
    "heure_fin": heureFin,
    "termine": termine,
    "en_retard": enRetard,
    "annule": annule,
  };

  /// 🆕 Créer depuis JSON (pour backend)
  factory Edt.fromJson(Map<String, dynamic> json) => Edt(
    niveau: json["niveau"],
    weekStart: DateTime.parse(json["week_start"]),
    jour: json["jour"],
    matiere: json["matiere"],
    professeur: json["professeur"],
    heureDebut: json["heure_debut"],
    heureFin: json["heure_fin"],
    termine: json["termine"] ?? false,
    enRetard: json["en_retard"] ?? false,
    annule: json["annule"] ?? false,
  );

  /// 🆕 Obtenir la date exacte du cours (jour de la semaine)
  DateTime get dateCours {
    final jourIndex = _jourToIndex(jour);
    return weekStart.add(Duration(days: jourIndex));
  }

  /// 🆕 Vérifier si ce cours est aujourd'hui
  bool get estAujourdhui {
    final aujourdhui = DateTime.now();
    final dateDuCours = dateCours;

    return dateDuCours.year == aujourdhui.year &&
        dateDuCours.month == aujourdhui.month &&
        dateDuCours.day == aujourdhui.day;
  }

  /// 🆕 Vérifier si ce cours appartient à la semaine actuelle
  bool get estSemaineActuelle {
    final aujourdhui = DateTime.now();
    final lundiActuel = aujourdhui.subtract(Duration(days: aujourdhui.weekday - 1));

    return weekStart.year == lundiActuel.year &&
        weekStart.month == lundiActuel.month &&
        weekStart.day == lundiActuel.day;
  }

  /// 🆕 Calculer le statut en temps réel (pour le Dashboard)
  String get statutActuel {
    if (annule) return "Annulé";
    if (termine) return "Terminé";
    if (enRetard) return "En retard";

    // Calculer selon l'heure actuelle
    if (!estAujourdhui) return "À venir";

    final maintenant = DateTime.now();
    final heureDebutParsed = _parseHeure(heureDebut);
    final heureFinParsed = _parseHeure(heureFin);

    if (maintenant.isBefore(heureDebutParsed)) return "À venir";
    if (maintenant.isAfter(heureFinParsed)) return "Terminé";

    return "En cours";
  }

  // ========== HELPERS PRIVÉS ==========

  /// Convertir jour en index (Lundi = 0, Dimanche = 6)
  int _jourToIndex(String jour) {
    const jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];
    return jours.indexOf(jour);
  }

  /// Parser une heure "14:30" en DateTime aujourd'hui
  DateTime _parseHeure(String heure) {
    final parts = heure.split(':');
    if (parts.length != 2) return DateTime.now();

    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, h, m);
  }

  /// 🆕 Copier avec modifications (utile pour les updates)
  Edt copyWith({
    String? niveau,
    DateTime? weekStart,
    String? jour,
    String? matiere,
    String? professeur,
    String? heureDebut,
    String? heureFin,
    bool? termine,
    bool? enRetard,
    bool? annule,
  }) {
    return Edt(
      niveau: niveau ?? this.niveau,
      weekStart: weekStart ?? this.weekStart,
      jour: jour ?? this.jour,
      matiere: matiere ?? this.matiere,
      professeur: professeur ?? this.professeur,
      heureDebut: heureDebut ?? this.heureDebut,
      heureFin: heureFin ?? this.heureFin,
      termine: termine ?? this.termine,
      enRetard: enRetard ?? this.enRetard,
      annule: annule ?? this.annule,
    );
  }
}