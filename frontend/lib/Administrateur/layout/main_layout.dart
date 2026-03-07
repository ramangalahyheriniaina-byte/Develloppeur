import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/navigation_view_model.dart';
import '../app/routes.dart';

import '../pages/Cours/view/cours_init_view.dart';
import '../pages/Cours/view/cours_list_view.dart';
import '../pages/Cours/view/upload_pdf.dart';
import '../pages/edt/view/edt_view.dart';
import '../pages/Dashboard/view/dashboard_view.dart';

import '../pages/Cours/view_models/cours_view_model.dart';
import '../pages/edt/view_model/edt_view_model.dart';
import '../pages/Dashboard/view_model/dashboard_view_model.dart';
import '../../../auth/view/login.dart';

class MainLayout extends StatefulWidget {
  final String userId;
  final String userName;

  const MainLayout({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? _anneeEnCours;
  bool _isLoading = true;
  bool _needsInitialization = false;
  bool _needsUpload = false;
  bool _isCheckingSetup = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSetupStatus();
    });
  }

  // Force la mise à jour de la navigation
  void _forceNavigationRefresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Vérification intelligente du setup
  Future<void> _checkSetupStatus() async {
    final coursVM = context.read<CoursViewModel>();

    try {
      coursVM.resetSetupCheck();
      final needsSetup = await coursVM.checkIfSetupNeeded();

      if (!mounted) return;

      if (needsSetup) {
        setState(() {
          _needsInitialization = true;
          _needsUpload = false;
          _anneeEnCours = null;
          _isLoading = false;
          _isCheckingSetup = false;
        });
        print('Système non configuré, redirection vers initialisation');
      } else {
        if (!coursVM.isInitialized) {
          await coursVM.loadInitialData();
        }

        if (!mounted) return;

        setState(() {
          _anneeEnCours = coursVM.anneeScolaire?.displayName;
          _needsInitialization = false;
          _needsUpload = false;
          _isLoading = false;
          _isCheckingSetup = false;
        });

        _forceNavigationRefresh();
        print('Système déjà configuré, affichage du dashboard');
      }
    } catch (e) {
      print('Erreur vérification setup: $e');
      if (!mounted) return;

      setState(() {
        _needsInitialization = true;
        _isLoading = false;
        _isCheckingSetup = false;
      });
    }
  }

  void _onInitializationComplete() {
    setState(() {
      _needsInitialization = false;
      _needsUpload = true;
    });
    _forceNavigationRefresh();
  }

  void _onUploadComplete() {
    final coursVM = context.read<CoursViewModel>();
    final navVM = context.read<NavigationViewModel>(); // AJOUT

    setState(() {
      _needsUpload = false;
      _anneeEnCours = coursVM.anneeScolaire?.displayName;
    });

    // FORCER LA NAVIGATION VERS LA LISTE DES COURS
    navVM.setCurrentRoute(Routes.cours);

    _forceNavigationRefresh();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuration terminée avec succès!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Se déconnecter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _performLogout();
    }
  }

  void _performLogout() {
    final coursVM = context.read<CoursViewModel>();
    coursVM.reset();
    coursVM.resetSetupCheck();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Écran de chargement
    if (_isLoading || _isCheckingSetup) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF629EB9)),
              ),
              const SizedBox(height: 24),
              Text(
                _isCheckingSetup ? 'Vérification de la configuration...' : 'Chargement...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final navVM = context.watch<NavigationViewModel>();
    final coursVM = context.watch<CoursViewModel>();
    final edtVM = context.watch<EdtViewModel>();
    final dashboardVM = context.watch<DashboardViewModel>();

    // Mise à jour des données
    dashboardVM.updateSeancesList(edtVM.seances);
    dashboardVM.updateCoursList(coursVM.cours);

    // Mise à jour des flags de navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (edtVM.seances.isNotEmpty) {
        navVM.markEdtExists(true);
      }
      if (coursVM.cours.isNotEmpty) {
        navVM.markCoursExists(true);
      }
    });

    // ========== SOLUTION : DÉTERMINATION DU CONTENU À AFFICHER ==========
    Widget content;

    if (_needsInitialization) {
      print('📋 Affichage: Initialisation');
      content = CoursInitView(onComplete: _onInitializationComplete);
    } else if (_needsUpload) {
      print(' Affichage: Upload PDF');
      content = UploadProgrammeView(onComplete: _onUploadComplete);
    } else {
      print(' Navigation normale - Route: ${navVM.currentRoute}');

      switch (navVM.currentRoute) {
        case Routes.programme:
          content = EdtView();
          break;
        case Routes.dashboard:
          content = const DashboardView();
          break;
        case Routes.cours:
        // SOLUTION SIMPLE : TOUJOURS ALLER VERS LISTE VIEW
          print(' Navigation vers CoursListView');
          content = const CoursListView();
          break;
        default:
          content = const DashboardView();
      }
    }

    return Scaffold(
      body: Row(
        children: [
          SidebarWithYear(
            anneeEnCours: _anneeEnCours,
            userName: widget.userName,
            userId: widget.userId,
            onLogout: () => _showLogoutDialog(context),
            needsInitialization: _needsInitialization || _needsUpload,
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class SidebarWithYear extends StatelessWidget {
  final String? anneeEnCours;
  final String userName;
  final String userId;
  final VoidCallback onLogout;
  final bool needsInitialization;

  const SidebarWithYear({
    super.key,
    this.anneeEnCours,
    required this.userName,
    required this.userId,
    required this.onLogout,
    this.needsInitialization = false,
  });

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();
    final coursVM = context.watch<CoursViewModel>();

    return Container(
      width: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4F8CA8),
            Color(0xFF629EB9),
            Color(0xFF76B0C8),
          ],
        ),
      ),
      child: Column(
        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 35, 20, 25),
            child: Column(
              children: [

                /// LOGO
                SizedBox(
                  height: 80,
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 60,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "EduFlow",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Admin: $userName",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "ID: $userId",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),

                if (anneeEnCours != null) ...[
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      anneeEnCours!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                if (needsInitialization) ...[
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Configuration requise",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// DIVIDER
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),

          const SizedBox(height: 20),

          /// MENU
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [

                  _menuItem(
                    context,
                    "Cours",
                    Icons.book_rounded,
                    Routes.cours,
                    navVM,
                    !needsInitialization,
                  ),

                  const SizedBox(height: 10),

                  _menuItem(
                    context,
                    "Emploi du temps",
                    Icons.calendar_month_rounded,
                    Routes.programme,
                    navVM,
                    !needsInitialization && coursVM.cours.isNotEmpty,
                  ),

                  const SizedBox(height: 10),

                  _menuItem(
                    context,
                    "Dashboard",
                    Icons.dashboard_rounded,
                    Routes.dashboard,
                    navVM,
                    true,
                  ),
                ],
              ),
            ),
          ),

          /// FOOTER
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [

                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22C55E),
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          needsInitialization
                              ? "Configuration en cours..."
                              : "System Online",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _menuItem(
                  context,
                  "Déconnexion",
                  Icons.logout_rounded,
                  Routes.logout,
                  navVM,
                  true,
                  isDanger: true,
                  customOnTap: onLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
      BuildContext context,
      String title,
      IconData icon,
      String route,
      NavigationViewModel navVM,
      bool enabled, {
        bool isDanger = false,
        VoidCallback? customOnTap,
      }) {

    final isActive = navVM.currentRoute == route;

    return InkWell(
      onTap: enabled
          ? () {
        if (customOnTap != null) {
          customOnTap();
        } else {
          navVM.setCurrentRoute(route);
        }
      }
          : null,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          )
              : null,
        ),
        child: Row(
          children: [

            Icon(
              icon,
              color: isDanger ? Colors.red : Colors.white,
              size: 22,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: enabled
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  fontSize: 14,
                  fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),

            if (isActive)
              const Icon(
                Icons.circle,
                size: 7,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}