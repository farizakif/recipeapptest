import 'package:equatable/equatable.dart';
import '../../data/models/recipe.dart';

/// Recipe Events
abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

/// Load all recipes
class LoadRecipes extends RecipeEvent {
  const LoadRecipes();
}

/// Filter recipes by type
class FilterRecipesByType extends RecipeEvent {
  final String recipeType;

  const FilterRecipesByType(this.recipeType);

  @override
  List<Object?> get props => [recipeType];
}

/// Add a new recipe
class AddRecipe extends RecipeEvent {
  final Recipe recipe;

  const AddRecipe(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

/// Update an existing recipe
class UpdateRecipe extends RecipeEvent {
  final Recipe recipe;

  const UpdateRecipe(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

/// Delete a recipe
class DeleteRecipe extends RecipeEvent {
  final int recipeId;

  const DeleteRecipe(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}
