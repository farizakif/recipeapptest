import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/recipe/recipe_bloc.dart';
import '../../bloc/recipe/recipe_event.dart';
import '../../bloc/recipe/recipe_state.dart';
import '../../core/utils/json_helper.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_page.dart';
import 'recipe_form_page.dart';

/// Recipe List Page - displays all recipes
class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  List<String> _recipeTypes = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadRecipeTypes();
    context.read<RecipeBloc>().add(const LoadRecipes());
  }

  Future<void> _loadRecipeTypes() async {
    final types = await JsonHelper.loadRecipeTypes();
    setState(() {
      _recipeTypes = ['All', ...types];
    });
  }

  void _filterRecipes(String? type) {
    if (type == null) return;
    setState(() {
      _selectedFilter = type;
    });
    
    if (type == 'All') {
      context.read<RecipeBloc>().add(const LoadRecipes());
    } else {
      context.read<RecipeBloc>().add(FilterRecipesByType(type));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe App'),
        actions: [
          if (_recipeTypes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<String>(
                value: _selectedFilter,
                underline: Container(),
                icon: const Icon(Icons.filter_list),
                dropdownColor: Theme.of(context).colorScheme.surface,
                items: _recipeTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: _filterRecipes,
              ),
            ),
        ],
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is RecipeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<RecipeBloc>().add(const LoadRecipes());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is RecipeLoaded) {
            if (state.recipes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.restaurant_menu, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'No recipes found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first recipe',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }
            
            return LayoutBuilder(
              builder: (context, constraints) {
                // Responsive grid
                int crossAxisCount = 1;
                if (constraints.maxWidth > 600) {
                  crossAxisCount = 2;
                }
                if (constraints.maxWidth > 900) {
                  crossAxisCount = 3;
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = state.recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(recipe: recipe),
                          ),
                        );
                        // Reload recipes if changes were made
                        if (result == true && context.mounted) {
                          context.read<RecipeBloc>().add(const LoadRecipes());
                        }
                      },
                    );
                  },
                );
              },
            );
          }
          
          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RecipeFormPage(),
            ),
          );
          if (result == true && context.mounted) {
            context.read<RecipeBloc>().add(const LoadRecipes());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
