import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PetDetailScreen extends StatelessWidget {
  final int id;
  const PetDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail'), backgroundColor: Colors.blue),
      body: FutureBuilder(
        future: ApiService().getPetDetail(id),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());

          final p = snap.data as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey[200],
                  child: Image.network(
                    'http://127.0.0.1:8000/images/${p['image']}',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.pets, size: 100, color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['name'],
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.pets, size: 20, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text("Type: ${p['type']}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              size: 20, color: Colors.green),
                          const SizedBox(width: 8),
                          Text("Prix: ${p['price']} DT",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("Description:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(p['description'],
                          style: const TextStyle(fontSize: 16, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
