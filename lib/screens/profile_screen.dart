// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../widgets/main_scaffold.dart';
import '../data/app_state.dart';
import '../models/listing.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _switchUser() {
    final current = AppState.instance.currentUserId;
    AppState.instance.currentUserId = current == 'user_1' ? 'user_2' : 'user_1';
    setState(() {});
  }

  void _navigateCreate() {
    Navigator.pushNamed(context, '/create').then((_) => setState(() {}));
  }

  void _remove(String id) {
    AppState.instance.listings.removeWhere((l) => l.id == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userId     = AppState.instance.currentUserId;
    final myListings = AppState.instance.getMyListings();

    return MainScaffold(
      currentIndex: 2,
      child: Column(
        children: [
          AppBar(
            title: Text('Usuario: $userId'),
            actions: [
              IconButton(icon: const Icon(Icons.add), onPressed: _navigateCreate),
            ],
          ),
          const Divider(),
          Expanded(
            child: myListings.isEmpty
                ? const Center(child: Text('No has publicado anuncios.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: myListings.length,
                    itemBuilder: (_, i) {
                      final l = myListings[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('${l.airline} - ${l.flightNumber}'),
                          subtitle: Text(
                              'Asiento: ${l.seat}\nFecha: ${l.date.toLocal().toString().split(' ')[0]}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _remove(l.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
