import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddPetScreen extends StatelessWidget {
  AddPetScreen({super.key});

  final _name = TextEditingController();
  final _type = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _image = TextEditingController();
  final _api = ApiService();

  void _showMsg(BuildContext context, String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: success ? Colors.green : Colors.red),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_name.text.isEmpty ||
        _type.text.isEmpty ||
        _desc.text.isEmpty ||
        _price.text.isEmpty ||
        _image.text.isEmpty) {
      _showMsg(context, '❌ Remplir tous les champs', false);
      return;
    }

    final success = await _api.addPet({
      'name': _name.text,
      'type': _type.text,
      'description': _desc.text,
      'price': int.parse(_price.text),
      'image': _image.text,
    });

    if (!context.mounted) return;

    _showMsg(context, success ? '✅ Animal ajouté!' : '❌ Erreur', success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Ajouter"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                      labelText: "Nom", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: _type,
                  decoration: const InputDecoration(
                      labelText: "Type", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: _desc,
                  decoration: const InputDecoration(
                      labelText: "Description", border: OutlineInputBorder()),
                  maxLines: 3),
              const SizedBox(height: 10),
              TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Prix (DT)", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: _image,
                  decoration: const InputDecoration(
                      labelText: "Image (ex: chien.jpg)",
                      border: OutlineInputBorder())),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => _submit(context),
                  child: const Text("Ajouter", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
