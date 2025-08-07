// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

import '../widgets/main_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      child: SafeArea(
        child: Column(
          children: [
            // ► AppBar blanco con texto e iconos grises
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
          
              title: const Text(
                'Perfil',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 24),

            // ► Avatar y nombre
            const CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage("assets/avatar.png"),
            ),
            const SizedBox(height: 12),
            const Text(
              'Adriano',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Viajero estrella',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),

            const SizedBox(height: 32),

            // ► Opciones
            _OptionTile(
              icon: Icons.list_alt,
              label: 'Anuncios publicados',
              onTap: () => Navigator.pushNamed(context, '/published_listings'),
            ),
            _OptionTile(
              icon: Icons.edit,
              label: 'Editar perfil',
              onTap: () => Navigator.pushNamed(context, '/edit_profile'),
            ),
            _OptionTile(
              icon: Icons.notifications,
              label: 'Configurar notificaciones',
              onTap: () =>
                  Navigator.pushNamed(context, '/notifications_settings'),
            ),
            _OptionTile(
              icon: Icons.report_problem,
              label: 'Reportar un problema',
              onTap: () => Navigator.pushNamed(context, '/report_problem'),
            ),
            _OptionTile(
              icon: Icons.info,
              label: 'Sobre la app',
              onTap: () => Navigator.pushNamed(context, '/about_app'),
            ),
            _OptionTile(
              icon: Icons.logout,
              label: 'Cerrar sesión',
              onTap: () => _showLogoutDialog(context),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _OptionTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: 16,
    );
  }
}
