import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc(FirebaseAuth instance) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) {
      final user = _auth.currentUser;
      emit(user != null ? Authenticated() : Unauthenticated());
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(Authenticated());
        emit(AuthLoggedOut());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _auth.signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError("Logout failed: ${e.toString()}"));
      }
    });
  }
}
