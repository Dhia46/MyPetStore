import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'pet_list_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _cin = TextEditingController();
  final _api = ApiService();

  void _msg(BuildContext c, String t, bool ok) =>
      ScaffoldMessenger.of(c).showSnackBar(
        SnackBar(
            content: Text(t), backgroundColor: ok ? Colors.green : Colors.red),
      );

  void _register(BuildContext c) {
    _user.clear();
    _pass.clear();
    _cin.clear();
    showDialog(
      context: c,
      builder: (ctx) => AlertDialog(
        title: const Text("Inscription"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _user,
                decoration: const InputDecoration(labelText: 'Username')),
            TextField(
                controller: _cin,
                decoration: const InputDecoration(labelText: 'CIN')),
            TextField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (_user.text.isEmpty ||
                  _cin.text.isEmpty ||
                  _pass.text.isEmpty) {
                _msg(c, '❌ Remplir tous les champs', false);
                return;
              }

              final r = await _api.register(_user.text, _cin.text, _pass.text);

              Navigator.pop(ctx);
              if (!c.mounted) return;

              if (r['success']) {
                // ✅ corrigé
                _msg(c, '✅ ${r['message']}', true);
                Navigator.pushReplacement(
                  c,
                  MaterialPageRoute(builder: (_) => const PetListScreen()),
                );
              } else {
                _msg(c, '❌ ${r['message']}', false);
              }
            },
            child: const Text("S'inscrire"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Connexion"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 100, color: Colors.blue),
            const SizedBox(height: 30),
            TextField(
                controller: _user,
                decoration: const InputDecoration(
                    labelText: 'Username', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  if (_user.text.isEmpty || _pass.text.isEmpty) {
                    _msg(c, '❌ Remplir tous les champs', false);
                    return;
                  }

                  final ok = await _api.login(_user.text, _pass.text);

                  if (!c.mounted) return;

                  if (ok) {
                    Navigator.pushReplacement(
                      c,
                      MaterialPageRoute(builder: (_) => const PetListScreen()),
                    );
                  } else {
                    _msg(c, '❌ Username ou mot de passe incorrect!', false);
                  }
                },
                child: const Text('Se connecter'),
              ),
            ),
            TextButton(
                onPressed: () => _register(c),
                child: const Text("Pas de compte ? S'inscrire")),
          ],
        ),
      ),
    );
  }
}
