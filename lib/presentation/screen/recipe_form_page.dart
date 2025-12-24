import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../bloc/recipe/recipe_bloc.dart';
import '../../bloc/recipe/recipe_event.dart';
import '../../data/models/recipe.dart';
import '../widgets/recipe_type_dropdown.dart';

class RecipeFormPage extends StatefulWidget {
  final Recipe? recipe;

  const RecipeFormPage({super.key, this.recipe});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final ingredientController = TextEditingController();
  final stepController = TextEditingController();

  String? selectedType;
  List<String> ingredients = [];
  List<String> steps = [];

  bool get isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    
    if (isEditing) {
      titleController.text = widget.recipe!.title;
      selectedType = widget.recipe!.recipeType;
      ingredients = List.from(widget.recipe!.ingredients);
      steps = List.from(widget.recipe!.steps);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    ingredientController.dispose();
    stepController.dispose();
    super.dispose();
  }

  void addIngredient() {
    if (ingredientController.text.trim().isNotEmpty) {
      setState(() {
        ingredients.add(ingredientController.text.trim());
        ingredientController.clear();
      });
    }
  }

  void removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void addStep() {
    if (stepController.text.trim().isNotEmpty) {
      setState(() {
        steps.add(stepController.text.trim());
        stepController.clear();
      });
    }
  }

  void removeStep(int index) {
    setState(() {
      steps.removeAt(index);
    });
  }

  void saveRecipe() {
    if (_formKey.currentState!.validate()) {
      if (ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient')),
        );
        return;
      }
      
      if (steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one step')),
        );
        return;
      }

      final recipe = Recipe(
        id: widget.recipe?.id,
        title: titleController.text.trim(),
        recipeType: selectedType!,
        imagePath: '',
        ingredients: ingredients,
        steps: steps,
      );

      if (isEditing) {
        context.read<RecipeBloc>().add(UpdateRecipe(recipe));
      } else {
        context.read<RecipeBloc>().add(AddRecipe(recipe));
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isEditing ? Icons.edit : Icons.add,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(isEditing ? 'Edit Recipe' : 'Create Recipe'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: saveRecipe,
              icon: const Icon(Icons.check, size: 20),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter a delicious recipe name',
                prefixIcon: Icon(Icons.restaurant_menu, color: colorScheme.primary),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a recipe title';
                }
                return null;
              },
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.1, end: 0, duration: 300.ms),
            const SizedBox(height: 20),

            RecipeTypeDropdown(
              selectedType: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 50.ms)
                .slideY(begin: -0.1, end: 0, duration: 300.ms, delay: 50.ms),
            const SizedBox(height: 32),

            // Ingredients Section
            buildSectionHeader(
              context,
              'Ingredients',
              Icons.shopping_basket_outlined,
              colorScheme.tertiary,
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ingredientController,
                      decoration: InputDecoration(
                        hintText: 'Add an ingredient...',
                        prefixIcon: Icon(Icons.add_shopping_cart, color: colorScheme.tertiary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onSubmitted: (_) => addIngredient(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: addIngredient,
                      icon: Icon(Icons.add_circle, color: colorScheme.tertiary),
                      tooltip: 'Add ingredient',
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideY(begin: -0.1, end: 0, duration: 300.ms, delay: 100.ms),
            const SizedBox(height: 12),
            if (ingredients.isNotEmpty)
              ...List.generate(ingredients.length, (index) {
                return buildIngredientChip(context, ingredients[index], index)
                    .animate()
                    .fadeIn(duration: 200.ms, delay: (index * 30).ms)
                    .slideX(begin: -0.1, end: 0, duration: 200.ms, delay: (index * 30).ms);
              }),
            const SizedBox(height: 32),

            // Steps Section
            buildSectionHeader(
              context,'Instructions',
              Icons.format_list_numbered,
              colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: stepController,
                      decoration: InputDecoration(
                        hintText: 'Describe a step...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      maxLines: 2,
                      onSubmitted: (_) => addStep(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8),
                    child: IconButton(
                      onPressed: addStep,
                      icon: Icon(Icons.add_circle, color: colorScheme.secondary),
                      tooltip: 'Add step',
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 150.ms)
                .slideY(begin: -0.1, end: 0, duration: 300.ms, delay: 150.ms),
            const SizedBox(height: 12),
            if (steps.isNotEmpty)
              ...List.generate(steps.length, (index) {
                return buildStepChip(context, steps[index], index)
                    .animate()
                    .fadeIn(duration: 200.ms, delay: (index * 30).ms)
                    .slideX(begin: -0.1, end: 0, duration: 200.ms, delay: (index * 30).ms);
              }),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton.icon(
              onPressed: saveRecipe,
              icon: const Icon(Icons.save_alt_rounded),
              label: Text(isEditing ? 'Update Recipe' : 'Create Recipe'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                minimumSize: const Size(double.infinity, 56),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 200.ms)
                .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget buildIngredientChip(BuildContext context, String ingredient, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => removeIngredient(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ingredient,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Icon(
                  Icons.close,
                  size: 20,
                  color: colorScheme.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStepChip(BuildContext context, String step, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => removeStep(index),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.secondary,
                        colorScheme.secondary.withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.close,
                  size: 20,
                  color: colorScheme.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
