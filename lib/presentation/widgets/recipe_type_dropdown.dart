import 'package:flutter/material.dart';

/// Recipe Type Dropdown Widget
class RecipeTypeDropdown extends StatelessWidget {
  final List<String> recipeTypes;
  final String? selectedType;
  final ValueChanged<String?> onChanged;

  const RecipeTypeDropdown({
    super.key,
    required this.recipeTypes,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedType,
      decoration: const InputDecoration(
        labelText: 'Recipe Type',
        prefixIcon: Icon(Icons.category),
      ),
      items: recipeTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a recipe type';
        }
        return null;
      },
    );
  }
}
