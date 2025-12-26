import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import '../../data/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final int index;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  recipe.imageBase64 != null && recipe.imageBase64!.isNotEmpty
                      ? Image.memory(
                          base64Decode(recipe.imageBase64!),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return buildFallbackImage(context, colorScheme, recipe);
                          },
                        )
                      : buildFallbackImage(context, colorScheme, recipe),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'By: Chef K. Aming',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      buildInfoChip(
                        context,
                        Icons.shopping_basket_outlined,
                        '${recipe.ingredients.length}',
                        colorScheme.tertiary,
                      ),
                      const SizedBox(width: 6),
                      buildInfoChip(
                        context,
                        Icons.format_list_numbered,
                        '${recipe.steps.length}',
                        colorScheme.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: (index * 50).ms);
  }

  Widget buildFallbackImage(BuildContext context, ColorScheme colorScheme, Recipe recipe) {
    if (recipe.imagePath.isNotEmpty) {
      return Image.asset(
        'assets/${recipe.imagePath}',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return buildGradientPlaceholder(colorScheme);
        },
      );
    }
    return buildGradientPlaceholder(colorScheme);
  }

  Widget buildInfoChip(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGradientPlaceholder(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.8),
            colorScheme.secondary.withOpacity(0.6),
          ],
        ),
      ),
      child: Icon(
        Icons.restaurant_menu,
        size: 64,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
