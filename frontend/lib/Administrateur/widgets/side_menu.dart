// 📁 lib/widgets/side_menu.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/navigation_view_model.dart';
import '../app/routes.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();

    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF629EB9),
            const Color(0xFF4A7C96),
          ],
        ),
      ),
      child: Column(
        children: [
          // Logo + titre
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1.25,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 180,
                    height: 170,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.school_rounded, size: 80, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'EduFlow',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          // Séparateur
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Menu items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    title: 'Cours',
                    icon: Icons.book_rounded,
                    route: Routes.cours,
                    navVM: navVM,
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    context,
                    title: 'Emploi du temps',
                    icon: Icons.calendar_month_rounded,
                    route: Routes.programme,
                    navVM: navVM,
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    context,
                    title: 'Dashboard',
                    icon: Icons.dashboard_rounded,
                    route: Routes.dashboard,
                    navVM: navVM,
                  ),
                ],
              ),
            ),
          ),

          // Footer - déconnexion
          Container(
            padding: const EdgeInsets.all(16),
            child: _buildMenuItem(
              context,
              title: 'Déconnexion',
              icon: Icons.logout_rounded,
              route: AppRoutes.logout, // redirection globale
              navVM: navVM,
              isDanger: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required String title,
        required IconData icon,
        required String route,
        required NavigationViewModel navVM,
        bool isDanger = false,
      }) {
    final isActive = navVM.currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (route == AppRoutes.logout) {
              // Déconnexion → retourne au login
              Navigator.pushReplacementNamed(context, AppRoutes.login);
              navVM.setCurrentRoute(Routes.cours); // reset page admin par défaut
            } else {
              navVM.setCurrentRoute(route);
            }
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.25)
                        : (isDanger
                        ? const Color(0xFFEF4444).withOpacity(0.15)
                        : Colors.white.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
