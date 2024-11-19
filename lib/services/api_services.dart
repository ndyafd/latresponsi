import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_model.dart';

class ApiService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Fetch meal list
  Future<List<Meal>> fetchMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s='));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List mealsData = data['meals'];
      return mealsData.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // Fetch meal details by id
  Future<Meal> fetchMealDetails(String mealId) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$mealId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final mealData = data['meals'][0];  // Ambil data meal pertama
      return Meal.fromJson(mealData);  // Mengonversi JSON ke objek Meal
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
