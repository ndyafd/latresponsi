class Meal {
  final String id;
  final String name;
  final String category;
  final String image;
  final String instructions;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.instructions,
  });

  // Method untuk mengonversi data JSON menjadi objek Meal
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],  // Pastikan kunci sesuai dengan data API
      name: json['strMeal'],
      category: json['strCategory'],
      image: json['strMealThumb'],
      instructions: json['strInstructions'],
    );
  }
}
