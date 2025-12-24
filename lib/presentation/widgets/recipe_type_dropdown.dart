import 'package:flutter/material.dart';
import '../../core/utils/json_helper.dart';

/// Recipe Type Dropdown Widget with Future.builder
class RecipeTypeDropdown extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onChanged;

  const RecipeTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return FutureBuilder<List<String>>(
      future: JsonHelper.loadRecipeTypes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Recipe Type',
              hintText: 'Loading...',
              prefixIcon: Icon(Icons.category, color: colorScheme.primary),
            ),
            items: const [],
            onChanged: null,
            dropdownColor: colorScheme.surface,
            style: Theme.of(context).textTheme.bodyLarge,
          );
        }
        
        if (snapshot.hasError) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Recipe Type',
              hintText: 'Error loading types',
              prefixIcon: Icon(Icons.error, color: colorScheme.error),
            ),
            items: const [],
            onChanged: null,
            dropdownColor: colorScheme.surface,
            style: Theme.of(context).textTheme.bodyLarge,
          );
        }
        
        final recipeTypes = snapshot.data ?? [];
        
        return DropdownButtonFormField<String>(
          value: selectedType,
          decoration: InputDecoration(
            labelText: 'Recipe Type',
            hintText: 'Select a recipe type',
            prefixIcon: Icon(Icons.category, color: colorScheme.primary),
          ),
          items: recipeTypes.map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 18,
                    color: colorScheme.primary.withOpacity(0.7),
                  ),
                  const SizedBox(width: 12),
                  Text(type),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a recipe type';
            }
            return null;
          },
          dropdownColor: colorScheme.surface,
          style: Theme.of(context).textTheme.bodyLarge,
        );
      },
    );
  }
}
