import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/recipe/recipe_bloc.dart';
import '../../bloc/recipe/recipe_event.dart';
import '../../bloc/recipe/recipe_state.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_page.dart';
import 'recipe_form_page.dart';
import '../../core/utils/json_helper.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(const LoadRecipes());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterRecipes(String category) {
    setState(() {
      selectedCategory = category;
    });
    
    if (category == 'All') {
      context.read<RecipeBloc>().add(const LoadRecipes());
    } else {
      context.read<RecipeBloc>().add(FilterRecipesByType(category));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
              return buildShimmerLoading(context);
          }
          
          if (state is RecipeError) {
              return buildErrorState(context, state.message);
            }
            
            if (state is RecipeLoaded) {
              if (state.recipes.isEmpty) {
                return buildEmptyState(context);
              }
              
              return ListView(
                children: [
                  buildHeader(context, colorScheme),
                  buildGreetingSection(context, colorScheme),
                  buildSearchBar(context, colorScheme),
                  buildFilterDropdown(context, colorScheme),
                  buildCategories(context, colorScheme),
                  buildSectionHeader(context,'${state.recipes.length} Recommendations','See More >',
                    colorScheme,
                  ),
                  buildHorizontalRecipeList(context, state.recipes, colorScheme),
                  buildSectionHeader(context,'${state.recipes.length} Breakfast Recipes','See More >',
                    colorScheme,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = state.recipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          index: index,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailPage(recipe: recipe),
                              ),
                            );
                            if (result == true && context.mounted) {
                              context.read<RecipeBloc>().add(const LoadRecipes());
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          
          return const Center(child: Text('Something went wrong'));
        },
      ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, colorScheme),
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
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fariz Akif',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGreetingSection(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget buildSearchBar(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search Recipe',
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget buildCategories(BuildContext context, ColorScheme colorScheme) {
    final categories = [
      'All',
      'Breakfast',
      'Lunch',
      'Dinner',
      'Dessert',
      'Snack',
      'Appetizer',
      'Soup',
      'Salad',
      'Beverage',
      'Vegetarian',
      'Vegan',
      'Gluten-Free',
    ];
    final categoryIcons = {
      'All': Icons.grid_view,
      'Breakfast': Icons.free_breakfast,
      'Lunch': Icons.lunch_dining,
      'Dinner': Icons.dinner_dining,
      'Dessert': Icons.cake,
      'Snack': Icons.fastfood,
      'Appetizer': Icons.local_dining,
      'Soup': Icons.soup_kitchen,
      'Salad': Icons.grass,
      'Beverage': Icons.local_cafe,
      'Vegetarian': Icons.eco,
      'Vegan': Icons.spa,
      'Gluten-Free': Icons.health_and_safety,
    };

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => _filterRecipes(category),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      categoryIcons[category] ?? Icons.restaurant_menu,
                      color: isSelected ? Colors.white : colorScheme.onSurface,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? colorScheme.primary : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildFilterDropdown(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder<List<String>>(
        future: JsonHelper.loadRecipeTypes(),
        builder: (context, snapshot) {
          final rawTypes = snapshot.data ?? [];
          final uniqueTypes = rawTypes.toSet().toList();
          final items = ['All', ...uniqueTypes];
          final safeValue = items.contains(selectedCategory) ? selectedCategory : 'All';
          return DropdownButtonFormField<String>(
            value: safeValue,
            decoration: InputDecoration(
              labelText: 'Filter by type',
              prefixIcon: Icon(Icons.category, color: colorScheme.primary),
            ),
            items: items.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _filterRecipes(value);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildSectionHeader(
    BuildContext context,
    String title,
    String seeMore,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              seeMore,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalRecipeList(
    BuildContext context,
    List recipes,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: recipes.length > 5 ? 5 : recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 16),
            child: RecipeCard(
              recipe: recipe,
              index: index,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(recipe: recipe),
                  ),
                );
                if (result == true && context.mounted) {
                  context.read<RecipeBloc>().add(const LoadRecipes());
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildShimmerLoading(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 18,
                            width: 45,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Container(
                            height: 18,
                            width: 45,
                            color: Colors.white,
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
      },
    );
  }

  Widget buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<RecipeBloc>().add(const LoadRecipes());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 80,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No recipes yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start creating delicious recipes!\nTap the + button to add your first recipe.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
