import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'pet_list_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _username = TextEditingController();
  final _cin = TextEditingController();
  final _password = TextEditingController();
  final _api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Inscription"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add, size: 100, color: Colors.green),
              const SizedBox(height: 30),
              TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                      labelText: 'Username', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: _cin,
                  decoration: const InputDecoration(
                      labelText: 'CIN', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (_username.text.isEmpty ||
                        _cin.text.isEmpty ||
                        _password.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('❌ Veuillez remplir tous les champs'),
                            backgroundColor: Colors.orange),
                      );
                      return;
                    }

                    final result = await _api.register(
                        _username.text, _cin.text, _password.text);

                    if (!context.mounted) return;

                    if (result['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('✅ ${result['message']}'),
                            backgroundColor: Colors.green),
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PetListScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('❌ ${result['message']}'),
                            backgroundColor: Colors.red),
                      );
                    }
                  },
                  child:
                      const Text("S'inscrire", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
