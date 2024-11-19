import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_model.dart';
import '../services/api_services.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<String>> _favoriteMeals;

  @override
  void initState() {
    super.initState();
    _favoriteMeals = _loadFavorites();
  }

  // Memuat daftar favorit dari SharedPreferences
  Future<List<String>> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Meals'),
      ),
      body: FutureBuilder<List<String>>(
        future: _favoriteMeals, // Memuat daftar ID makanan favorit
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final favoriteMealIds = snapshot.data!;
            
            return FutureBuilder<List<Meal>>(
              future: ApiService().fetchMeals(),
              builder: (context, mealSnapshot) {
                if (mealSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (mealSnapshot.hasError) {
                  return Center(child: Text('Error: ${mealSnapshot.error}'));
                } else if (mealSnapshot.hasData) {
                  final meals = mealSnapshot.data!;
                  final favoriteMeals = meals.where((meal) => favoriteMealIds.contains(meal.id)).toList();

                  return ListView.builder(
                    itemCount: favoriteMeals.length,
                    itemBuilder: (context, index) {
                      final meal = favoriteMeals[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(meal.name),
                          leading: Image.network(
                            meal.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(meal.id), // Navigate to detail screen
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No meals available'));
                }
              },
            );
          } else {
            return const Center(child: Text('No favorite meals found.'));
          }
        },
      ),
    );
  }
}
