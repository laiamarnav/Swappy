// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

import 'package:swappy/core/responsive/responsive.dart';
import 'package:swappy/infrastructure/auth/auth_service.dart';
import 'package:swappy/infrastructure/di/locator.dart';
import 'package:swappy/presentation/widgets/adaptive_scaffold.dart';
import 'package:swappy/screens/auth_gate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = ['/notifications', '/search', '/profile'];

    void onSelect(int i) {
      if (i == 2) return;
      Navigator.pushReplacementNamed(context, routes[i]);
    }

    void goToCreate() {
      Navigator.of(context).pushNamed('/create');
    }

    return AdaptiveScaffold(
      currentIndex: 2,
      onSelect: onSelect,
      fab: FloatingActionButton(
        onPressed: goToCreate,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= Breakpoints.tablet;

            // Header with avatar and name.
            final header = Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                SizedBox(height: space(context)),
                const Text(
                  'Adriano',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: space(context) / 2),
                Text(
                  'Viajero estrella',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            );

            // Options list reused in both layouts.
            final options = <Widget>[
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
                onTap: () => Navigator.pushNamed(context, '/notifications_settings'),
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
            ];

            Widget content;
            if (isWide) {
              content = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: header),
                  SizedBox(width: space(context)),
                  Expanded(
                    flex: 3,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (_, i) => options[i],
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemCount: options.length,
                    ),
                  ),
                ],
              );
            } else {
              content = ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: options.length + 2,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) return header;
                  if (index == 1) return SizedBox(height: space(context) * 2);
                  return options[index - 2];
                },
              );
            }

            return Padding(
              padding: EdgeInsets.all(gutter(context)),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
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
                      SizedBox(width: space(context)),
                    ],
                  ),
                  SizedBox(height: space(context) * 2),
                  Expanded(child: content),
                ],
              ),
            );
          },
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
              locator<AuthService>().signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                    (_) => false,
                  );
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
        padding: EdgeInsets.all(space(context) / 1.5),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: gutter(context) / 2),
      horizontalTitleGap: space(context),
    );
  }
}
