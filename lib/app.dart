import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/recipe/recipe_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/recipe_repository.dart';
import 'presentation/pages/recipe_list_page.dart';

/// Main App Widget
class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(
        repository: RecipeRepository(),
      ),
      child: MaterialApp(
        title: 'Recipe App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const RecipeListPage(),
      ),
    );
  }
}
