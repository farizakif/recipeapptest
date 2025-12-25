import 'dart:convert';
import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final int? id;
  final String title;
  final String recipeType;
  final String imagePath;
  final String? imageBase64;
  final List<String> ingredients;
  final List<String> steps;

  const Recipe({
    this.id,
    required this.title,
    required this.recipeType,
    required this.imagePath,
    this.imageBase64,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int?,
      title: json['title'] as String,
      recipeType: json['recipeType'] as String,
      imagePath: json['imagePath'] as String,
      imageBase64: json['imageBase64'] as String?,
      ingredients: List<String>.from(jsonDecode(json['ingredients'] as String) as List,),
      steps: List<String>.from(jsonDecode(json['steps'] as String) as List,),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'recipeType': recipeType,
      'imagePath': imagePath,
      'imageBase64': imageBase64,
      'ingredients': jsonEncode(ingredients),
      'steps': jsonEncode(steps),
    };
  }

  Recipe copyWith({
    int? id,
    String? title,
    String? recipeType,
    String? imagePath,
    String? imageBase64,
    List<String>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      recipeType: recipeType ?? this.recipeType,
      imagePath: imagePath ?? this.imagePath,
      imageBase64: imageBase64 ?? this.imageBase64,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [id, title, recipeType, imagePath, imageBase64, ingredients, steps];
}
