import 'package:equatable/equatable.dart';
import '../../data/models/recipe.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecipes extends RecipeEvent {
  const LoadRecipes();
}

class FilterRecipesByType extends RecipeEvent {
  final String recipeType;

  const FilterRecipesByType(this.recipeType);

  @override
  List<Object?> get props => [recipeType];
}

class AddRecipe extends RecipeEvent {
  final Recipe recipe;

  const AddRecipe(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class UpdateRecipe extends RecipeEvent {
  final Recipe recipe;

  const UpdateRecipe(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class DeleteRecipe extends RecipeEvent {
  final int recipeId;

  const DeleteRecipe(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}
