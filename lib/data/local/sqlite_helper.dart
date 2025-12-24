import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';

class SQLiteHelper {
  static final SQLiteHelper instance = SQLiteHelper._internal();
  static Database? _database;

  SQLiteHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'recipes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        recipeType TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        steps TEXT NOT NULL
      )
    ''');

    await insertSampleRecipes(db);
  }

  Future<void> insertSampleRecipes(Database db) async {
    final sampleRecipes = [
      Recipe(
        title: 'Classic Pancakes',
        recipeType: 'Breakfast',
        imagePath: 'assets/pancakes.avif',
        ingredients: [
          '2 cups all-purpose flour',
          '2 tablespoons sugar',
          '2 teaspoons baking powder',
          '1 teaspoon salt',
          '2 eggs',
          '1.5 cups milk',
          '2 tablespoons melted butter',
        ],
        steps: [
          'Mix dry ingredients in a large bowl',
          'Whisk eggs, milk, and melted butter in another bowl',
          'Pour wet ingredients into dry ingredients and mix until just combined',
          'Heat a griddle over medium heat',
          'Pour 1/4 cup batter for each pancake',
          'Cook until bubbles form, then flip and cook until golden',
        ],
      ),
      Recipe(
        title: 'Caesar Salad',
        recipeType: 'Lunch',
        imagePath: 'assets/caesar.png',
        ingredients: [
          '1 head romaine lettuce',
          '1/2 cup Caesar dressing',
          '1/4 cup parmesan cheese',
          '1 cup croutons',
          'Black pepper',
        ],
        steps: [
          'Wash and chop romaine lettuce',
          'Place lettuce in a large bowl',
          'Add Caesar dressing and toss well',
          'Top with parmesan cheese and croutons',
          'Add black pepper to taste',
          'Serve & enjoy',
        ],
      ),
      Recipe(
        title: 'Spaghetti Carbonara',
        recipeType: 'Dinner',
        imagePath: 'assets/carbonara.webp',
        ingredients: [
          '400g spaghetti',
          '200g pancetta or bacon',
          '4 large eggs',
          '100g parmesan cheese',
          'Black pepper',
          'Salt',
        ],
        steps: [
          'Cook spaghetti in salted boiling water',
          'Fry pancetta until crispy',
          'Beat eggs with grated parmesan',
          'Drain pasta, reserving 1 cup pasta water',
          'Mix hot pasta with pancetta',
          'Remove from heat, add egg mixture, toss quickly',
          'Add pasta water if needed for creaminess',
          'Season with black pepper and serve',
        ],
      ),
      Recipe(
        title: 'Chocolate Chip Cookies',
        recipeType: 'Dessert',
        imagePath: 'assets/cookies.avif',
        ingredients: [
          '2 cups flour',
          '1 tsp baking soda',
          '1 cup butter, softened',
          '3/4 cup sugar',
          '3/4 cup brown sugar',
          '2 eggs',
          '2 tsp vanilla extract',
          '2 cups chocolate chips',
        ],
        steps: [
          'Preheat oven to 375F (190C)',
          'Mix flour and baking soda in a bowl',
          'Cream butter and both sugars until fluffy',
          'Beat in eggs and vanilla',
          'Gradually blend in flour mixture',
          'Stir in chocolate chips',
          'Drop rounded tablespoons onto ungreased sheets',
          'Bake 9-11 minutes until golden brown',
          'Cool on baking sheet for 2 minutes',
        ],
      ),
      Recipe(
        title: 'Veggie Stir Fry',
        recipeType: 'Vegetarian',
        imagePath: 'assets/veggie.png',
        ingredients: [
          '2 cups mixed vegetables',
          '2 tablespoons soy sauce',
          '1 tablespoon sesame oil',
          '2 cloves garlic, minced',
          '1 teaspoon ginger, grated',
          'Cooked rice for serving',
        ],
        steps: [
          'Heat sesame oil in a wok or large pan',
          'Add garlic and ginger, stir fry for 30 seconds',
          'Add vegetables and stir fry for 5-7 minutes',
          'Add soy sauce and toss well',
          'Serve hot over rice',
        ],
      ),
    ];

    for (final recipe in sampleRecipes) {
      await db.insert('recipes', recipe.toJson());
    }
  }

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert('recipes', recipe.toJson());
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) => Recipe.fromJson(maps[i]));
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update(
      'recipes',
      recipe.toJson(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recipe>> getRecipesByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'recipeType = ?',
      whereArgs: [type],
    );
    return List.generate(maps.length, (i) => Recipe.fromJson(maps[i]));
  }

  Future<void> clearAllRecipes() async {
    final db = await database;
    await db.delete('recipes');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}