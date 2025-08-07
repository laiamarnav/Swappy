// lib/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = 'Adriano';
  String _subtitle = 'Viajero estrella';

  Widget _buildField(IconData icon, String hint, String initialValue, ValueChanged<String?> onSaved) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 16),
            validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Editar perfil',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
              ),
              const SizedBox(height: 24),

              // Card con los campos
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      _buildField(Icons.person, 'Nombre', _name, (v) => _name = v ?? _name),
                      const Divider(),
                      _buildField(Icons.edit, 'Subtítulo', _subtitle, (v) => _subtitle = v ?? _subtitle),
                    ],
                  ),
                ),
              ),


              const Spacer(),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: persistir en AppState o backend
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5078F2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
