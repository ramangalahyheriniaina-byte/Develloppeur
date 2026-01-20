import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/navigation_view_model.dart';
import '../app/routes.dart';

import '../pages/cours/view/cours_view.dart';
import '../pages/edt/view/edt_view.dart';
import '../pages/Dashboard/view/dashboard_view.dart';

import '../pages/cours/view_model/cours_view_model.dart';
import '../pages/edt/view_model/edt_view_model.dart';
import '../pages/Dashboard/view_model/dashboard_view_model.dart';

import '../widgets/side_menu.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<NavigationViewModel>();
    final coursVM = context.read<CoursViewModel>();
    final edtVM = context.read<EdtViewModel>();
    final dashboardVM = context.read<DashboardViewModel>();

    //  Dashboard reçoit les EDT actuels
    dashboardVM.updateEdtList(edtVM.edtCourant());

    Widget content;

    switch (navVM.currentRoute) {
      case Routes.programme: // Emploi du temps
        content = EdtView();
        break;

      case Routes.dashboard: // Dashboard
        content = const DashboardView();
        break;

      case Routes.cours: // Gestion des cours (default)
      default:
        content = CoursView();
    }

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(child: content),
        ],
      ),
    );
  }
}