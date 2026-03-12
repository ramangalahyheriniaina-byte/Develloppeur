// lib/Administrateur/pages/Cours/view/cours_list_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/cours_view_model.dart';
import '../models/classe_model.dart';
import '../models/matiere_model.dart';
import '../models/prof_model.dart';

class CoursListView extends StatefulWidget {
  const CoursListView({Key? key}) : super(key: key);

  @override
  State<CoursListView> createState() => _CoursListViewState();
}

class _CoursListViewState extends State<CoursListView> {
  final Map<int, bool> _expandedClasses = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoursViewModel>().loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoursViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),

          /// APPBAR FIXE
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            toolbarHeight: 90,
            titleSpacing: 24,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tableau de Bord de Répartition des Matières',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  viewModel.anneeScolaire?.displayName ?? "2026-2027",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5568),
                  ),
                ),
                Text(
                  '${viewModel.totalClasses} classes • ${viewModel.totalMatieres} matières',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),

          /// BODY SCROLLABLE
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [

                  /// STATS ROW
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildStatsCard(viewModel),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _buildProfessorsSection(context, viewModel),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: _buildProfsCountCard(viewModel),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// PROGRAMMES
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: viewModel.classes.map((classe) {
                          return SizedBox(
                            width: (constraints.maxWidth - 20) / 2,
                            child: _buildProgramCard(
                              context,
                              classe,
                              viewModel,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  /// FOOTER
                  Center(
                    child: Text(
                      '© Copyright ${viewModel.anneeScolaire?.displayName ?? "2026-2027"} • EduFlow Platform version 2.0.1 • All rights reserved • Contact Support',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA0AEC0),
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// STATS CARD
  Widget _buildStatsCard(CoursViewModel viewModel) {
    final totalMatieres = viewModel.totalMatieres;
    final avecProf = viewModel.matieresAvecProf;
    final sansProf = viewModel.matieresSansProf;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatRing(
            number: '$avecProf',
            label: 'Avec prof',
            icon: Icons.person,
            progress: totalMatieres > 0 ? avecProf / totalMatieres : 0,
            ringColor: Color(0xFF48BB78),
            backgroundColor: Color(0xFFF0FFF4),
          ),
          const SizedBox(width: 8),
          _buildStatRing(
            number: '$sansProf',
            label: 'Sans prof',
            icon: Icons.more_horiz,
            progress: totalMatieres > 0 ? sansProf / totalMatieres : 0,
            ringColor: Color(0xFFED8936),
            backgroundColor: Color(0xFFFFF7E5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRing({
    required String number,
    required String label,
    required IconData icon,
    required double progress,
    required Color ringColor,
    required Color backgroundColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 3,
                  backgroundColor: Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
                ),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(ringColor),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: ringColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// PROFESSORS SECTION
  Widget _buildProfessorsSection(BuildContext context, CoursViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: Color(0xFF4A5568),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Professeurs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
                _buildAddProfButton(context, viewModel),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Table Header
          Container(
            color: Color(0xFFF7FAFC),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Nom du Professeur',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      const SizedBox(width: 4),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            // Logique de tri à implémenter
                          },
                          child: Icon(Icons.unfold_more, size: 14, color: Color(0xFFA0AEC0)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Text(
                        'Statut des Cours',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      const SizedBox(width: 4),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            // Logique de tri à implémenter
                          },
                          child: Icon(Icons.unfold_more, size: 14, color: Color(0xFFA0AEC0)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Professor Rows
          if (viewModel.profs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.person_off, size: 48, color: Color(0xFFCBD5E0)),
                    const SizedBox(height: 12),
                    Text(
                      'Aucun professeur',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...viewModel.profs.map((prof) => _buildProfessorRow(prof, viewModel, context)),
        ],
      ),
    );
  }

  Widget _buildProfessorRow(Prof prof, CoursViewModel viewModel, BuildContext context) {
    final nbCours = viewModel.cours
        .where((c) => c.idProf == prof.idProf)
        .length;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEDF2F7), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(0xFFEDF2F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        prof.nomProf.isNotEmpty ? prof.nomProf[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      prof.nomProf,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D3748),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                nbCours == 0
                    ? 'Aucun cours'
                    : '$nbCours cours affecté${nbCours > 1 ? "s" : ""}',
                style: TextStyle(
                  fontSize: 13,
                  color: nbCours > 0 ? Color(0xFF2D3748) : Color(0xFFA0AEC0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF718096),
                          size: 16,
                        ),
                        onPressed: () {
                          // À implémenter : modifier professeur
                        },
                        padding: EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Color(0xFFF56565),
                          size: 16,
                        ),
                        onPressed: () => _showSupprimerProfDialog(
                          context,
                          prof,
                          viewModel,
                        ),
                        padding: EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProfButton(BuildContext context, CoursViewModel viewModel) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showAjouterProfDialog(context, viewModel),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF2D7A8F),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                'Ajouter un Prof',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// PROFS COUNT CARD
  Widget _buildProfsCountCard(CoursViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${viewModel.profs.length}',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Profs',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// PROGRAM CARD - Avec effet de curseur
  Widget _buildProgramCard(
      BuildContext context,
      Classe classe,
      CoursViewModel viewModel) {
    _expandedClasses.putIfAbsent(classe.idClasse!, () => false);
    final totalHeures = viewModel.getTotalHeuresClasse(classe);
    final nbMatieres = classe.matieres?.length ?? 0;

    final matieresAvecProf = classe.matieres?.where((m) =>
    viewModel.getCoursForMatiere(m.idMatiere!) != null
    ).length ?? 0;
    final progress = nbMatieres > 0 ? matieresAvecProf / nbMatieres : 0.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _expandedClasses[classe.idClasse!] = !_expandedClasses[classe.idClasse!]!;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Programme ${classe.nomClasse}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Color(0xFFEDF2F7),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$nbMatieres matières • $totalHeures heures totales',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        'Full list',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D7A8F),
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF2D7A8F).withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_expandedClasses[classe.idClasse!]! && (classe.matieres?.isNotEmpty ?? false))
                Container(
                  color: Color(0xFFF7FAFC),
                  child: Column(
                    children: [
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      ...classe.matieres!.map((matiere) =>
                          _buildMatiereCard(matiere, viewModel, context)
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// MATIERE CARD - Avec effet de curseur sur les éléments interactifs
  Widget _buildMatiereCard(
      Matiere matiere,
      CoursViewModel viewModel,
      BuildContext context) {
    final cours = viewModel.getCoursForMatiere(matiere.idMatiere!);
    final hasProf = cours != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matiere.nomMatiere,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${matiere.heureTotale}h',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasProf ? Color(0xFFE3F2F5) : Color(0xFFFEF5E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              hasProf
                  ? viewModel.getProfById(cours.idProf)?.nomProf ?? "Prof"
                  : "Sans prof",
              style: TextStyle(
                fontSize: 10,
                color: hasProf ? Color(0xFF2D7A8F) : Color(0xFFB8860B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              icon: Icon(
                Icons.person_add,
                color: hasProf ? Color(0xFF2D7A8F) : Color(0xFF2D7A8F),
                size: 18,
              ),
              onPressed: () {
                _showAffecterProfDialog(context, matiere, viewModel);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  /// DIALOGUES (inchangés)
  void _showAjouterProfDialog(BuildContext context, CoursViewModel viewModel) {
    final controller = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.person_add, color: Color(0xFF2D7A8F)),
              SizedBox(width: 12),
              Text('Ajouter un professeur'),
            ],
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nom du professeur',
              hintText: 'Ex: M. Dupont, Mme Martin...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            autofocus: true,
            enabled: !isLoading,
            onSubmitted: (_) async {
              if (controller.text.trim().isNotEmpty && !isLoading) {
                setDialogState(() => isLoading = true);
                await viewModel.ajouterProf(controller.text.trim());
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (controller.text.trim().isNotEmpty) {
                  setDialogState(() => isLoading = true);
                  await viewModel.ajouterProf(controller.text.trim());
                  if (context.mounted) Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7A8F),
              ),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSupprimerProfDialog(
      BuildContext context,
      Prof prof,
      CoursViewModel viewModel,
      ) {
    final nbCours = viewModel.cours.where((c) => c.idProf == prof.idProf).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer ce professeur ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Êtes-vous sûr de vouloir supprimer ${prof.nomProf} ?'),
            if (nbCours > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Color(0xFFF59E0B), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$nbCours affectation${nbCours > 1 ? "s" : ""} sera${nbCours > 1 ? "ont" : ""} supprimée${nbCours > 1 ? "s" : ""}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await viewModel.supprimerProf(prof.idProf!);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAffecterProfDialog(
      BuildContext context,
      Matiere matiere,
      CoursViewModel viewModel,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Affecter un prof'),
            const SizedBox(height: 4),
            Text(
              matiere.nomMatiere,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF2D7A8F),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 350,
          child: viewModel.profs.isEmpty
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_off, size: 48, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 16),
              const Text(
                'Aucun professeur disponible',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Veuillez d\'abord ajouter des professeurs.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showAjouterProfDialog(context, viewModel);
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Ajouter un prof'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D7A8F),
                ),
              ),
            ],
          )
              : ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.profs.length,
            itemBuilder: (context, index) {
              final prof = viewModel.profs[index];
              final nbCours = viewModel.cours
                  .where((c) => c.idProf == prof.idProf)
                  .length;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF2D7A8F).withOpacity(0.1),
                  child: Text(
                    prof.nomProf[0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF2D7A8F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(prof.nomProf),
                subtitle: Text('$nbCours cours déjà affecté${nbCours > 1 ? "s" : ""}'),
                onTap: () async {
                  await viewModel.affecterProfAMatiere(
                    idMatiere: matiere.idMatiere!,
                    idProf: prof.idProf!,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${prof.nomProf} affecté à ${matiere.nomMatiere}',
                        ),
                        backgroundColor: const Color(0xFF10B981),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }
}