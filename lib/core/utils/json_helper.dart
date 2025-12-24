import 'dart:convert';
import 'package:flutter/services.dart';

/// Utility class for loading JSON assets
class JsonHelper {
  /// Load and parse a JSON file from assets
  static Future<Map<String, dynamic>> loadJsonAsset(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString) as Map<String, dynamic>;
  }
  
  /// Load recipe types from assets
  static Future<List<String>> loadRecipeTypes() async {
    try {
      final data = await loadJsonAsset('assets/recipetypes.json');
      final List<dynamic> types = data['recipeTypes'] as List<dynamic>;
      return types.map((e) => e.toString()).toList();
    } catch (e) {
      // Return default types if asset loading fails
      return [
        'Breakfast',
        'Lunch',
        'Dinner',
        'Dessert',
        'Snack',
        'Appetizer',
      ];
    }
  }
}
