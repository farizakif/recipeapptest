import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/recipe_repository.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;

  RecipeBloc({required this.repository}) : super(const RecipeInitial()) {
    on<LoadRecipes>(onLoadRecipes);
    on<FilterRecipesByType>(onFilterRecipesByType);
    on<AddRecipe>(onAddRecipe);
    on<UpdateRecipe>(onUpdateRecipe);
    on<DeleteRecipe>(onDeleteRecipe);
  }

  Future<void> onLoadRecipes(
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

  Future<void> onFilterRecipesByType(
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

  Future<void> onAddRecipe(
    AddRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      await repository.addRecipe(event.recipe);
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to add recipe: $e'));
    }
  }

  Future<void> onUpdateRecipe(
    UpdateRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      await repository.updateRecipe(event.recipe);
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to update recipe: $e'));
    }
  }

  Future<void> onDeleteRecipe(
    DeleteRecipe event,
    Emitter<RecipeState> emit,
  ) async {
    try {
      await repository.deleteRecipe(event.recipeId);
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError('Failed to delete recipe: $e'));
    }
  }
}
