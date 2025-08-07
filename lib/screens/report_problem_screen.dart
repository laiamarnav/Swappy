// lib/screens/report_problem_screen.dart

import 'package:flutter/material.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _comment = '';

  Widget _buildField(
    IconData icon,
    String hint,
    String initialValue,
    int maxLines,
    ValueChanged<String?> onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              onSaved: onSaved,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      // TODO: enviar al backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado, ¡gracias!')),
      );
      Navigator.of(context).pop();
    }
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
          'Reportar un problema',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ilustración
                Image.asset(
                  'assets/warning.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),

                // Título amigable
                const Text(
                  '¿Qué sucede?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Tarjeta con campos
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      _buildField(
                        Icons.person,
                        'Tu nombre',
                        _name,
                        1,
                        (v) => _name = v ?? '',
                      ),
                      const Divider(),
                      _buildField(
                        Icons.email,
                        'Tu correo electrónico',
                        _email,
                        1,
                        (v) => _email = v ?? '',
                      ),
                      const Divider(),
                      _buildField(
                        Icons.comment,
                        'Describe tu problema',
                        _comment,
                        4,
                        (v) => _comment = v ?? '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botón enviar
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5078F2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Enviar reporte',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
