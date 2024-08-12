import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/config/theme/app_theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme(isDarkMode: false));
  void toggleTheme() {
    final newTheme = state.copyWith(isDarkMode: !state.isDarkMode);
    emit(newTheme);
  }
}
