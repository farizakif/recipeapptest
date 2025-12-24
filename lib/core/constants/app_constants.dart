/// App Constants
class AppConstants {
  static const String appName = 'Recipe App';
  static const String dbName = 'recipes.db';
  static const int dbVersion = 1;
  
  // Table names
  static const String recipesTable = 'recipes';
  
  // Column names
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnRecipeType = 'recipeType';
  static const String columnImagePath = 'imagePath';
  static const String columnIngredients = 'ingredients';
  static const String columnSteps = 'steps';
  
  // Assets
  static const String recipeTypesAsset = 'assets/recipetypes.json';
}
