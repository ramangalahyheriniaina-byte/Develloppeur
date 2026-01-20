import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Administrateur/app/routes.dart';

// AUTH
import 'auth/view_model/login_view_model.dart';

// CORE / NAVIGATION
import 'Administrateur/core/navigation_view_model.dart';

// ADMIN VIEW MODELS
import 'Administrateur/pages/cours/view_model/cours_view_model.dart';
import 'Administrateur/pages/edt/view_model/edt_view_model.dart';
import 'Administrateur/pages/Dashboard/view_model/dashboard_view_model.dart';

void main() {
  runApp(const EduFlowApp());
}

class EduFlowApp extends StatelessWidget {
  const EduFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// AUTH
        ChangeNotifierProvider(create: (_) => LoginViewModel()),

        /// NAVIGATION ADMIN
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),

        /// ADMIN VIEW MODELS
        ChangeNotifierProvider(create: (_) => CoursViewModel()),
        ChangeNotifierProvider(create: (_) => EdtViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EduFlow',

        ///  THEME
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'OpenSans',
        ),

        ///ROUTING
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}


