import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/recipe_repository.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

/// Recipe BLoC - manages recipe state
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;

  RecipeBloc({required this.repository}) : super(const RecipeInitial()) {
    // Load recipes
    on<LoadRecipes>(_onLoadRecipes);
    
    // Filter recipes by type
    on<FilterRecipesByType>(_onFilterRecipesByType);
    
    // Add recipe
    on<AddRecipe>(_onAddRecipe);
    
    // Update recipe
    on<UpdateRecipe>(_onUpdateRecipe);
    
    // Delete recipe
    on<DeleteRecipe>(_onDeleteRecipe);
  }

  /// Load all recipes
  Future<void> _onLoadRecipes(
    LoadRecipes event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    try {
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to load recipes: $e'));
    }
  }

  /// Filter recipes by type
  Future<void> _onFilterRecipesByType(
    FilterRecipesByType event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    try {
      final recipes = await repository.getRecipesByType(event.recipeType);
      emit(RecipeLoaded(recipes, filterType: event.recipeType));
    } catch (e) {
      emit(RecipeError('Failed to filter recipes: $e'));
    }
  }

  /// Add a new recipe
  Future<void> _onAddRecipe(
    AddRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      await repository.addRecipe(event.recipe);
      // Reload recipes after adding
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to add recipe: $e'));
    }
  }

  /// Update an existing recipe
  Future<void> _onUpdateRecipe(
    UpdateRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      await repository.updateRecipe(event.recipe);
      // Reload recipes after updating
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to update recipe: $e'));
    }
  }

  /// Delete a recipe
  Future<void> _onDeleteRecipe(
    DeleteRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      await repository.deleteRecipe(event.recipeId);
      // Reload recipes after deleting
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to delete recipe: $e'));
    }
  }
}
