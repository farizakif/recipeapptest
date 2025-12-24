import 'dart:convert';
import 'package:flutter/services.dart';

class JsonHelper {
  static Future<Map<String, dynamic>> loadJsonAsset(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString) as Map<String, dynamic>;
  }
  
  static Future<List<String>> loadRecipeTypes() async {
    try {
      final data = await loadJsonAsset('assets/recipetypes.json');
      final List<dynamic> types = data['recipeTypes'] as List<dynamic>;
      return types.map((e) => e.toString()).toList();
    } catch (e) {
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
