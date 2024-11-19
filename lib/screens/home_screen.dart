import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/meal_model.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> _favoriteMeals;

  @override
  void initState() {
    super.initState();
    _favoriteMeals = _loadFavorites();
  }

  Future<List<String>> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> _addToFavorites(Meal meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMeals = prefs.getStringList('favorites') ?? [];
    if (!favoriteMeals.contains(meal.id)) {
      favoriteMeals.add(meal.id);
    }
    await prefs.setStringList('favorites', favoriteMeals);
    setState(() {
      _favoriteMeals = Future.value(favoriteMeals);
    });
  }

  Future<void> _removeFromFavorites(Meal meal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteMeals = prefs.getStringList('favorites') ?? [];
    favoriteMeals.remove(meal.id);
    await prefs.setStringList('favorites', favoriteMeals);
    setState(() {
      _favoriteMeals = Future.value(favoriteMeals);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal List'),
        backgroundColor: Colors.deepPurple, // Matching the theme color (similar to DetailScreen)
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                );
              },
              child: Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.white), // Icon color
                  SizedBox(width: 4),
                  Text(
                    'Favorit Saya',
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Meal>>(
        future: ApiService().fetchMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final meals = snapshot.data!;
            return FutureBuilder<List<String>>(
              future: _favoriteMeals,
              builder: (context, favoriteSnapshot) {
                if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (favoriteSnapshot.hasError) {
                  return Center(child: Text('Error: ${favoriteSnapshot.error}'));
                } else if (favoriteSnapshot.hasData) {
                  final favoriteMeals = favoriteSnapshot.data!;
                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      bool isFavorite = favoriteMeals.contains(meal.id);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(meal.name),
                          subtitle: Text(meal.category),
                          leading: Image.network(meal.image, width: 50, fit: BoxFit.cover),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            onPressed: () {
                              if (isFavorite) {
                                _removeFromFavorites(meal); 
                              } else {
                                _addToFavorites(meal); 
                              }
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(meal.id), 
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
            return const Center(child: Text('No meals available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Icon(Icons.exit_to_app),
        backgroundColor: Colors.red, 
      ),
    );
  }
}
