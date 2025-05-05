import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance_app/core/common/bloc/theme_event.dart';
import 'package:personal_finance_app/core/common/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>((event, emit) {
      final newMode =
          state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeState(themeMode: newMode));
    });
  }
}
