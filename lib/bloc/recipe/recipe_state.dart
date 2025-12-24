import 'package:equatable/equatable.dart';
import '../../data/models/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {
  const RecipeInitial();
}

class RecipeLoading extends RecipeState {
  const RecipeLoading();
}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  final String? filterType;

  const RecipeLoaded(this.recipes, {this.filterType});

  @override
  List<Object?> get props => [recipes, filterType];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecipeOperationSuccess extends RecipeState {
  final String message;

  const RecipeOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
