import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/meal_model.dart';

class DetailScreen extends StatelessWidget {
  final String mealId;

  const DetailScreen(this.mealId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details'),
        backgroundColor: Colors.pinkAccent, // Ubah warna AppBar sesuai tema
      ),
      body: FutureBuilder<Meal>(
        future: ApiService().fetchMealDetails(mealId), // Fetch meal details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul makanan dengan style yang lebih menonjol
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent, // Sesuaikan dengan warna tema
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Kategori dengan sedikit lebih besar
                  Text(
                    'Category: ${meal.category}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  
                  // Gambar makanan dengan border dan shadow
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      meal.image,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Menambahkan divider untuk memisahkan bagian
                  const Divider(color: Colors.grey, thickness: 1.5),
                  const SizedBox(height: 16),
                  
                  // Instructions section
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w600, 
                      color: Colors.pinkAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Menampilkan instruksi
                  Text(
                    meal.instructions,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Meal not found'));
          }
        },
      ),
    );
  }
}
