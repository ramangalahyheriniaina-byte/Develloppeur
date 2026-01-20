import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/Administrateur/pages/cours/models/cours_model.dart';
import 'package:frontend/Administrateur/pages/cours/view_model/cours_view_model.dart';
import '../view_model/edt_view_model.dart';

class EdtView extends StatelessWidget {
  EdtView({super.key});

  final TextEditingController debutCtrl = TextEditingController();
  final TextEditingController finCtrl = TextEditingController();

  final List<String> jours = [
    "Lundi",
    "Mardi",
    "Mercredi",
    "Jeudi",
    "Vendredi",
    "Samedi"
  ];

  @override
  Widget build(BuildContext context) {
    final edtVM = context.watch<EdtViewModel>();
    final coursVM = context.watch<CoursViewModel>();

    final List<Cours> coursDuNiveau = coursVM.coursList
        .where((c) => c.niveau == edtVM.selectedNiveau)
        .toList();

    return Container(
      color: Color(0xFFF8FAFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et sous-titre
            Text(
              'Emploi du Temps',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Organisez vos cours de manière optimale',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),

            // Sélecteurs de semaine et date
            Row(
              children: [
                // Semaine
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: edtVM.selectedWeekStart,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );

                    if (picked != null) {
                      final monday = picked.subtract(
                        Duration(days: picked.weekday - 1),
                      );
                      edtVM.changerSemaine(monday);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Color(0xFF629EB9)),
                        const SizedBox(width: 8),
                        Text(
                          'Semaine du ${edtVM.selectedWeekStart.day
                              .toString()
                              .padLeft(2, '0')} janvier au ${edtVM
                              .selectedWeekStart
                              .add(Duration(days: 6))
                              .day
                              .toString()
                              .padLeft(2, '0')} janvier ${edtVM
                              .selectedWeekStart.year}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Jour sélectionné
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Builder(
                        builder: (context) {
                          // Calculer la date du jour sélectionné dans la semaine
                          final jourIndex = jours.indexOf(edtVM.selectedJour);
                          final dateJourSelectionne = edtVM.selectedWeekStart
                              .add(Duration(days: jourIndex));

                          return Text(
                            '${edtVM.selectedJour} ${dateJourSelectionne
                                .day} janvier ${dateJourSelectionne.year}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sélecteur de niveau (Pills)
            Row(
              children: ['L1', 'L2', 'L3', 'M1', 'M2'].map((niveau) {
                final selected = edtVM.selectedNiveau == niveau;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => edtVM.changerNiveau(niveau),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? Color(0xFFEC4899) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        niveau,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Carte "Ajouter une Séance"
            Container(
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
              child: coursDuNiveau.isEmpty
                  ? Column(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 64,
                    color: Color(0xFFCBD5E1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun cours disponible pour ${edtVM.selectedNiveau}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Créez d\'abord des cours dans la section Gestion des Cours',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFFEC4899),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ajouter une Séance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Formulaire en ligne
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Jour
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Jour',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: edtVM.selectedJour,
                                isExpanded: true,
                                underline: SizedBox(),
                                items: jours
                                    .map((j) =>
                                    DropdownMenuItem(
                                      value: j,
                                      child: Text(j,
                                          style: TextStyle(
                                              fontSize: 14)),
                                    ))
                                    .toList(),
                                onChanged: (v) => edtVM.changerJour(v!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Début
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Début',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: debutCtrl,
                              decoration: InputDecoration(
                                hintText: '--:-- --',
                                hintStyle: TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: Icon(Icons.access_time,
                                    size: 18, color: Color(0xFF94A3B8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Fin
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Fin',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: finCtrl,
                              decoration: InputDecoration(
                                hintText: '--:-- --',
                                hintStyle: TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: Icon(Icons.access_time,
                                    size: 18, color: Color(0xFF94A3B8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Matière
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.book_outlined,
                                    size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Matière',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<Cours>(
                                hint: Text('Sélectionner...',
                                    style: TextStyle(
                                      color: Color(0xFFCBD5E1),
                                      fontSize: 14,
                                    )),
                                value: edtVM.selectedCours,
                                isExpanded: true,
                                underline: SizedBox(),
                                items: coursDuNiveau
                                    .map((c) =>
                                    DropdownMenuItem(
                                      value: c,
                                      child: Text(c.matiere,
                                          style: TextStyle(
                                              fontSize: 14)),
                                    ))
                                    .toList(),
                                onChanged: (v) =>
                                    edtVM.selectionnerCours(v!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Bouton Ajouter au planning
                  ElevatedButton.icon(
                    onPressed: edtVM.selectedCours == null
                        ? null
                        : () {
                      edtVM.ajouterEdt(
                        heureDebut: debutCtrl.text,
                        heureFin: finCtrl.text,
                        context,
                      );
                      debutCtrl.clear();
                      finCtrl.clear();
                    },
                    icon: Icon(Icons.calendar_month, size: 18),
                    label: Text('Ajouter au planning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEC4899),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Color(0xFFE2E8F0),
                      disabledForegroundColor: Color(0xFF94A3B8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Titre section EDT créé
            Row(
              children: [
                Icon(Icons.calendar_month,
                    color: Color(0xFFEC4899), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Emploi du Temps Créé - ${edtVM.selectedNiveau}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // EDT Table
            if (edtVM
                .edtCourant()
                .isEmpty)
              Container(
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
                        'Aucune séance planifiée',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Commencez à construire votre emploi du temps',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
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
                child: Column(
                  children: [
                    // En-tête du tableau
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Heure',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...jours.map((jour) =>
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    jour,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: jour == edtVM.selectedJour
                                          ? Color(0xFFEC4899)
                                          : Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),

                    // Contenu du tableau
                    ...edtVM.edtCourant().map((e) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFF1F5F9)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${e.heureDebut} -\n${e.heureFin}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ),
                            ...jours.map((jour) {
                              if (jour == edtVM.selectedJour) {
                                return Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFDFF3FF),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Color(0xFF629EB9), width: 1),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.matiere,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.person_outline,
                                                size: 12,
                                                color: Color(0xFF64748B)),
                                            const SizedBox(width: 4),
                                            Text(
                                              e.professeur,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Expanded(
                                flex: 2,
                                child: SizedBox(),
                              );
                            }),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}