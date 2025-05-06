import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_finance_app/apis/firebase_api.dart';
import 'package:personal_finance_app/core/common/bloc/theme_bloc.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_event.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_state.dart';
import 'package:personal_finance_app/features/auth/ui/login_screen.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_bloc.dart';
import 'package:personal_finance_app/features/finances/bloc/finances_event.dart';
import 'package:personal_finance_app/features/home/ui/home_screen.dart';
import 'features/auth/bloc/auth_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => FinanceBloc(FirebaseAPIs())..add(LoadTransactionsEvent()),
        ),
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (_) => AuthBloc(FirebaseAuth.instance)),
      ],
      child: const FinanceApp(),
    ),
  );
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeBloc>().state.themeMode,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) =>
                    AuthBloc(FirebaseAuth.instance)
                      ..add(CheckAuthStatusEvent()),
          ),
          BlocProvider(
            create:
                (context) =>
                    FinanceBloc(FirebaseAPIs())..add(LoadTransactionsEvent()),
          ),
        ],
        child: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen(); // Replace with your home screen widget
        } else if (state is Unauthenticated) {
          return const LoginScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
