import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import '../constants/app_keys.dart';
import '../transitions.dart'; // Custom transitions
import 'onboarding_screen.dart'; // Navigate after register

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _name     = TextEditingController();
  final _email    = TextEditingController();
  final _password = TextEditingController();
  final _confirm  = TextEditingController();
  bool _obscure = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
  if (!(_formKey.currentState?.validate() ?? false)) return;
  if (!_acceptTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debes aceptar los términos')),
    );
    return;
  }

  // Simula registro OK → guarda sesión
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(AppKeys.authUserId, 'user_demo');

  // Ve al Onboarding post-registro con animación scale + fade
  if (!mounted) return;
  Navigator.of(context).pushReplacement(
    ScaleFadePageRoute(page: const OnboardingScreen()),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // Added Hero for shared logo between screens
        title: const Hero(
          tag: 'app-logo',
          child: Image(image: AssetImage('assets/logo.png'), height: 32),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Crea tu cuenta',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Únete a Swappy en segundos',
                style: TextStyle(
                  color: Color(0xFF5E5E5E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              color: Colors.white,
              elevation: 8,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _InputRow(
                        icon: Icons.person,
                        hint: 'Nombre',
                        controller: _name,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      _InputRow(
                        icon: Icons.email,
                        hint: 'Correo electrónico',
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          if (!v.contains('@')) return 'Correo inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _InputRow(
                        icon: Icons.lock,
                        hint: 'Contraseña',
                        controller: _password,
                        obscureText: _obscure,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) =>
                            (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                      ),
                      const SizedBox(height: 12),
                      _InputRow(
                        icon: Icons.lock_outline,
                        hint: 'Confirmar contraseña',
                        controller: _confirm,
                        obscureText: _obscure,
                        validator: (v) =>
                            v != _password.text ? 'Las contraseñas no coinciden' : null,
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: AppColors.primary,
                            onChanged: (v) =>
                                setState(() => _acceptTerms = v ?? false),
                          ),
                          const Expanded(
                            child: Text(
                              'Acepto los términos y condiciones',
                              style: TextStyle(color: Color(0xFF5E5E5E)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Crear cuenta',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _InputRow({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
