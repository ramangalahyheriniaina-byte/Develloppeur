// 📁 lib/features/dashboard/views/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../edt/view_model/edt_view_model.dart';
import '../models/dashboard_model.dart';
import '../view_model/dashboard_view_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Consumer2<DashboardViewModel, EdtViewModel>(
        builder: (context, vm, edtVM, _) {
          // Vérifier si un EDT a été créé (au moins un EDT existe)
          final bool edtExiste = edtVM.tousLesEdt().isNotEmpty; //  Correction

          // Si aucun EDT créé, message de blocage
          if (!edtExiste) {
            return Container(
              color: Color(0xFFF8FAFC),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard_outlined,
                      size: 120,
                      color: Color(0xFFCBD5E1),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Dashboard non disponible',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Créez d\'abord un emploi du temps pour accéder au dashboard',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.calendar_month, size: 18),
                      label: Text('Aller à l\'emploi du temps'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF629EB9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 🔹 Mettre à jour la liste d'EDT avec TOUS les EDT
          vm.updateEdtList(edtVM.tousLesEdt()); // 🆕 Correction

          // 🔹 Récupérer les cours EN COURS actuellement
          final List<DashboardModel> cours = vm.dashboardCours();

          // 🆕 Date actuelle
          final DateTime aujourdhui = DateTime.now();
          final String jourActuel = vm.jourActuel;

          return Container(
            color: Color(0xFFF8FAFC),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête avec salutation et date actuelle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bonjour, Admin !',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('👋', style: TextStyle(fontSize: 28)),
                        ],
                      ),
                      // 🆕 Afficher la date actuelle
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFF86EFAC)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16,
                                color: Color(0xFF166534)),
                            const SizedBox(width: 8),
                            Text(
                              '$jourActuel ${aujourdhui.day} janvier ${aujourdhui.year}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF166534),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Bandeau "Cours en cours"
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF629EB9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cours en cours',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // 🆕 Compteur de cours en cours
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${cours.length} cours',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grille de cours
                  cours.isEmpty
                      ? Container(
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy_rounded,
                            size: 64,
                            color: Color(0xFFCBD5E1),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun cours en cours actuellement', // 🆕 Message modifié
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Les cours en cours apparaîtront ici', // 🆕 Message modifié
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: cours.length,
                    itemBuilder: (context, index) {
                      final dm = cours[index];

                      // 🆕 Utiliser les helpers du modèle
                      final bgColor = dm.couleurs['background']!;
                      final badgeColor = dm.couleurs['badge']!;

                      return Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            // En-tête : niveau et badge statut
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF629EB9),
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    dm.edt.niveau,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withOpacity(0.2),
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(dm.icone, // 🆕 Icône dynamique
                                          size: 12,
                                          color: badgeColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        dm.badgeText, // 🆕 Badge dynamique
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: badgeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Matière et prof
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dm.edt.matiere,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.person_outline,
                                        size: 14,
                                        color: Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        dm.edt.professeur,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                // 🆕 Description avec temps restant
                                const SizedBox(height: 4),
                                Text(
                                  dm.description,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: badgeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            // Heure + boutons actions
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 14,
                                        color: Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${dm.edt.heureDebut} - ${dm.edt.heureFin}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // 🆕 Boutons conditionnels basés sur les helpers
                                    if (dm.peutEtreAnnule)
                                      InkWell(
                                        onTap: () => vm.annulerCours(dm),
                                        child: Text(
                                          'Annuler',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEF4444),
                                          ),
                                        ),
                                      ),
                                    if (dm.peutEtreAnnule &&
                                        dm.peutEtreMarqueEnRetard)
                                      const SizedBox(width: 12),
                                    if (dm.peutEtreMarqueEnRetard)
                                      InkWell(
                                        onTap: () => vm.marquerEnRetard(dm),
                                        child: Text(
                                          'En retard',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFF97316),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // Section "Avancement des cours" (reste inchangée)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Avancement des cours',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'January',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Layout : Avancement à gauche, Calendrier à droite
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carte d'avancement
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Onglets
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Engagement',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Color(0xFF629EB9),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Par matière',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF629EB9),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // ⚠️ DONNÉES FICTIVES - En attendant le backend
                              _buildProgressBar(
                                  'L1', 'Mathématiques', 0.4, Color(0xFF3B82F6)),
                              const SizedBox(height: 20),
                              _buildProgressBar(
                                  'M1', 'Deep Learning', 0.6, Color(0xFF22C55E)),
                              const SizedBox(height: 20),
                              _buildProgressBar(
                                  'L2', 'Scripting Bash', 0.15, Color(0xFF8B5CF6)),
                              const SizedBox(height: 20),
                              _buildProgressBar(
                                  'L2', 'Python', 0.9, Color(0xFFF59E0B)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      // Mini calendrier (reste inchangé)
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 350,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'January 2026',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.chevron_left, size: 20),
                                      Icon(Icons.chevron_right, size: 20),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']
                                    .map((d) => Text(
                                  d,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ))
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  itemCount: 31,
                                  itemBuilder: (context, index) {
                                    final isToday = index == 16; // 17 janvier
                                    return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isToday
                                            ? Color(0xFF629EB9)
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isToday
                                              ? Colors.white
                                              : Color(0xFF64748B),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(
      String niveau, String matiere, double progress, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                niveau,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                matiere,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}