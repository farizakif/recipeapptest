import 'package:flutter/material.dart';
import '../../data/models/recipe.dart';

/// Recipe Card Widget
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Container(
              height: 150,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.restaurant_menu,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            // Recipe Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Title
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Recipe Type Chip
                  Chip(
                    label: Text(
                      recipe.recipeType,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(height: 8),
                  
                  // Ingredients and Steps Count
                  Row(
                    children: [
                      Icon(
                        Icons.list,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.ingredients.length} ingredients',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.format_list_numbered,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.steps.length} steps',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
