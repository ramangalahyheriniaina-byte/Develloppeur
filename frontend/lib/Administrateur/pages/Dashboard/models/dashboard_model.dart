// 📁 lib/features/dashboard/Model/dashboard_model.dart

import 'package:flutter/material.dart';
import '../../edt/models/edtModel.dart';

class DashboardModel {
  final Edt edt;

  DashboardModel({required this.edt});

  factory DashboardModel.fromEdt(Edt edt) {
    return DashboardModel(edt: edt);
  }

  /// Statut (pour "En cours", devrait toujours être "En cours" dans le Dashboard)
  String get statut => edt.statutActuel;

  /// Couleurs selon le statut
  Map<String, Color> get couleurs {
    // Pour un cours annulé même s'il était en cours
    if (edt.annule) {
      return {
        'background': Color(0xFFF1F5F9),
        'badge': Color(0xFF64748B),
      };
    }

    // Pour un cours en retard
    if (edt.enRetard) {
      return {
        'background': Color(0xFFFEE2E2),
        'badge': Color(0xFFEF4444),
      };
    }

    // Cours en cours normal
    return {
      'background': Color(0xFFDCFCE7),
      'badge': Color(0xFF22C55E),
    };
  }

  /// Icône selon le statut
  IconData get icone {
    if (edt.annule) return Icons.cancel_outlined;
    if (edt.enRetard) return Icons.schedule;
    return Icons.play_circle_outline; // En cours
  }

  /// Badge texte
  String get badgeText {
    if (edt.annule) return "Annulé";
    if (edt.enRetard) return "En retard";
    return "En cours";
  }

  /// Temps restant avant la fin du cours (en minutes)
  int get tempsRestantMinutes {
    try {
      final maintenant = DateTime.now();
      final fin = _parseHeure(edt.heureFin);
      final diff = fin.difference(maintenant).inMinutes;
      return diff > 0 ? diff : 0;
    } catch (e) {
      return 0;
    }
  }

  /// Description avec temps restant
  String get description {
    if (edt.annule) return "Cours annulé";

    final restant = tempsRestantMinutes;
    if (restant > 0) {
      final heures = restant ~/ 60;
      final minutes = restant % 60;

      if (heures > 0) {
        return "Se termine dans ${heures}h${minutes.toString().padLeft(2, '0')}";
      }
      return "Se termine dans $minutes min";
    }

    return "Se termine bientôt";
  }

  /// Actions disponibles
  List<String> get actionsDisponibles {
    if (edt.annule) return [];
    return ["Annuler", "Marquer en retard"];
  }

  bool get peutEtreAnnule => !edt.annule;
  bool get peutEtreMarqueEnRetard => !edt.enRetard && !edt.annule;

  DateTime _parseHeure(String heure) {
    try {
      final parts = heure.split(':');
      if (parts.length != 2) return DateTime.now();

      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, h, m);
    } catch (e) {
      return DateTime.now();
    }
  }
}