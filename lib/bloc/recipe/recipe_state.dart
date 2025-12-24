import 'package:equatable/equatable.dart';
import '../../data/models/recipe.dart';

/// Recipe States
abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RecipeInitial extends RecipeState {
  const RecipeInitial();
}

/// Loading state
class RecipeLoading extends RecipeState {
  const RecipeLoading();
}

/// Loaded state with recipes
class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  final String? filterType;

  const RecipeLoaded(this.recipes, {this.filterType});

  @override
  List<Object?> get props => [recipes, filterType];
}

/// Error state
class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Recipe operation success (add, update, delete)
class RecipeOperationSuccess extends RecipeState {
  final String message;

  const RecipeOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
