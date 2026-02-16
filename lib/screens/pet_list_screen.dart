import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_pet_screen.dart';
import 'pet_detail_screen.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  final api = ApiService();
  int _key = 0;

  void _refresh() => setState(() => _key++);

  Future<void> _buy(Map pet) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirmer'),
        content: Text('Acheter ${pet['name']} pour ${pet['price']} DT ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Non')),
          ElevatedButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Oui')),
        ],
      ),
    );

    if (ok != true) return;

    final success = await api.buyPet(pet['id']);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '✅ ${pet['name']} acheté!' : '❌ Erreur'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Marketplace"), backgroundColor: Colors.blue),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddPetScreen()));
          if (result == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        key: ValueKey(_key),
        future: api.getPets(),
        builder: (_, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());

          final pets = snap.data as List;
          if (pets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text('Aucun animal',
                      style: TextStyle(fontSize: 18, color: Colors.grey))
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: pets.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (_, i) {
              final p = pets[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'http://127.0.0.1:8000/images/${p['image']}',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.pets)),
                    ),
                  ),
                  title: Text(p['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${p['type']} - ${p['price']} DT"),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PetDetailScreen(id: p['id']))),
                  trailing: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _buy(p),
                    child: const Text("Acheter"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
