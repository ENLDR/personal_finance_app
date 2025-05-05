import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_bloc.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_event.dart';
import 'package:personal_finance_app/features/auth/bloc/auth_state.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Column(
            children: [
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: passController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final pass = passController.text;
                  if (isLogin) {
                    context.read<AuthBloc>().add(LoginRequested(email, pass));
                  } else {
                    context.read<AuthBloc>().add(RegisterRequested(email, pass));
                  }
                },
                child: Text(isLogin ? "Login" : "Register"),
              ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? "Don't have an account? Register" : "Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
