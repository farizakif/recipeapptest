import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/recipe/recipe_bloc.dart';
import '../../bloc/recipe/recipe_event.dart';
import '../../core/utils/json_helper.dart';
import '../../data/models/recipe.dart';
import '../widgets/recipe_type_dropdown.dart';

/// Recipe Form Page - Add/Edit Recipe
class RecipeFormPage extends StatefulWidget {
  final Recipe? recipe;

  const RecipeFormPage({super.key, this.recipe});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _stepController = TextEditingController();

  List<String> _recipeTypes = [];
  String? _selectedType;
  List<String> _ingredients = [];
  List<String> _steps = [];

  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    _loadRecipeTypes();
    
    if (_isEditing) {
      _titleController.text = widget.recipe!.title;
      _selectedType = widget.recipe!.recipeType;
      _ingredients = List.from(widget.recipe!.ingredients);
      _steps = List.from(widget.recipe!.steps);
    }
  }

  Future<void> _loadRecipeTypes() async {
    final types = await JsonHelper.loadRecipeTypes();
    setState(() {
      _recipeTypes = types;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addStep() {
    if (_stepController.text.trim().isNotEmpty) {
      setState(() {
        _steps.add(_stepController.text.trim());
        _stepController.clear();
      });
    }
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one ingredient')),
        );
        return;
      }
      
      if (_steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one step')),
        );
        return;
      }

      final recipe = Recipe(
        id: widget.recipe?.id,
        title: _titleController.text.trim(),
        recipeType: _selectedType!,
        imagePath: 'assets/default_recipe.png',
        ingredients: _ingredients,
        steps: _steps,
      );

      if (_isEditing) {
        context.read<RecipeBloc>().add(UpdateRecipe(recipe));
      } else {
        context.read<RecipeBloc>().add(AddRecipe(recipe));
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Recipe' : 'Add Recipe'),
        actions: [
          IconButton(
            onPressed: _saveRecipe,
            icon: const Icon(Icons.check),
            tooltip: 'Save Recipe',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a recipe title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Recipe Type Dropdown
            if (_recipeTypes.isNotEmpty)
              RecipeTypeDropdown(
                recipeTypes: _recipeTypes,
                selectedType: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
            const SizedBox(height: 24),

            // Ingredients Section
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: const InputDecoration(
                      hintText: 'Add ingredient',
                      prefixIcon: Icon(Icons.add_shopping_cart),
                    ),
                    onSubmitted: (_) => _addIngredient(),
                  ),
                ),
                IconButton(
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add_circle),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_ingredients.isNotEmpty)
              ...List.generate(_ingredients.length, (index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(_ingredients[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeIngredient(index),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),

            // Steps Section
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stepController,
                    decoration: const InputDecoration(
                      hintText: 'Add step',
                      prefixIcon: Icon(Icons.format_list_numbered),
                    ),
                    maxLines: 2,
                    onSubmitted: (_) => _addStep(),
                  ),
                ),
                IconButton(
                  onPressed: _addStep,
                  icon: const Icon(Icons.add_circle),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_steps.isNotEmpty)
              ...List.generate(_steps.length, (index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(_steps[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeStep(index),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveRecipe,
              icon: const Icon(Icons.save),
              label: Text(_isEditing ? 'Update Recipe' : 'Save Recipe'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
