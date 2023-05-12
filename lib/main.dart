import 'package:admin_panel_cui/screens/faculty.dart';
import 'package:admin_panel_cui/screens/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'screens/students.dart';

void main() async {
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          authDomain: "cuimessenger.firebaseapp.com",
          apiKey: "AIzaSyC6zooMl_aS_HC5UDCD305mCYqeu_QEkGw",
          appId: "1:975117575433:web:b27ad193963a97fdc5dfd8",
          messagingSenderId: "975117575433",
          projectId: "cuimessenger"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(title: 'Admin Panel', initialRoute: '/', routes: {
        '/': (context) => const StudentAdminPanel(),
        FacultyAdminPanel.routeName: (context) => const FacultyAdminPanel(),
        NotificationPanel.routeName: (context) => const NotificationPanel(),
      }),
    );
  }
}
