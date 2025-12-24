/// Recipe Type Model
class RecipeType {
  final String name;

  const RecipeType({required this.name});

  factory RecipeType.fromJson(String json) {
    return RecipeType(name: json);
  }

  String toJson() => name;

  @override
  String toString() => name;
}
