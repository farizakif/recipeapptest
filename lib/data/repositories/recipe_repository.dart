import '../models/recipe.dart';
import '../local/sqlite_helper.dart';

/// Recipe Repository - handles data operations
class RecipeRepository {
  final SQLiteHelper _dbHelper;

  RecipeRepository({SQLiteHelper? dbHelper})
      : _dbHelper = dbHelper ?? SQLiteHelper.instance;

  /// Get all recipes
  Future<List<Recipe>> getAllRecipes() async {
    try {
      return await _dbHelper.getRecipes();
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }

  /// Get recipes by type
  Future<List<Recipe>> getRecipesByType(String type) async {
    try {
      if (type.isEmpty || type == 'All') {
        return await getAllRecipes();
      }
      return await _dbHelper.getRecipesByType(type);
    } catch (e) {
      throw Exception('Failed to load recipes by type: $e');
    }
  }

  /// Add a new recipe
  Future<int> addRecipe(Recipe recipe) async {
    try {
      return await _dbHelper.insertRecipe(recipe);
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  /// Update an existing recipe
  Future<int> updateRecipe(Recipe recipe) async {
    try {
      if (recipe.id == null) {
        throw Exception('Recipe ID cannot be null for update');
      }
      return await _dbHelper.updateRecipe(recipe);
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }

  /// Delete a recipe
  Future<int> deleteRecipe(int id) async {
    try {
      return await _dbHelper.deleteRecipe(id);
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
}
