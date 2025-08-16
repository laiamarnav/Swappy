import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _slides = const [
    _SlideData(
      title: "Encuentra tu\nsiguiente destino",
      subtitle:
          "Busca asientos disponibles y filtra por origen, destino y fecha.",
      imageAsset: "assets/plane_search.png",
    ),
    _SlideData(
      title: "Publica e\nintercambia",
      subtitle:
          "Sube tu asiento fácilmente y gestiona solicitudes en un solo lugar.",
      imageAsset: "assets/seat_post.png",
    ),
    _SlideData(
      title: "Conecta con\nviajeros",
      subtitle:
          "Chatea, acepta o rechaza; organiza tu viaje sin complicaciones.",
      imageAsset: "assets/travel_chat.png",
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('seenOnboarding', true);

  if (!context.mounted) return;
  Navigator.pushReplacementNamed(context, '/');
  }

  void _next() {
    if (_index < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar blanco con logo centrado (sin flecha)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // Hero to match register/login logo transitions
        title: const Hero(
          tag: 'app-logo',
          child: Image(image: AssetImage('assets/logo.png'), height: 32),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final s = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabecera con título a la izquierda y adorno a la derecha
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 120),
                              child: Text(
                                s.title,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  height: 1.15,
                                ),
                              ),
                            ),
                            // Adorno: círculo degradado en la esquina superior derecha
                            Positioned(
                              top: -20,
                              right: -10,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.18),
                                      AppColors.primary.withOpacity(0.0),
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Ilustración centrada
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              s.imageAsset,
                              fit: BoxFit.contain,
                              // tamaño adaptable
                              width: MediaQuery.of(context).size.width * 0.75,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Subtítulo
                        Text(
                          s.subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots + acciones
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Row(
                children: [
                  // Botón Saltar
                  TextButton(
                    onPressed: _skip,
                    child: const Text('Saltar'),
                  ),
                  const Spacer(),
                  // Dots
                  Row(
                    children: List.generate(
                      _slides.length,
                      (i) => _Dot(active: i == _index, color: AppColors.primary),
                    ),
                  ),
                  const Spacer(),
                  // Siguiente / Empezar
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                      ),
                      child: Text(
                        _index == _slides.length - 1 ? 'Empezar' : 'Siguiente',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Datos de cada slide
class _SlideData {
  final String title;
  final String subtitle;
  final String imageAsset;
  const _SlideData({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });
}

// Dot indicador animado
class _Dot extends StatelessWidget {
  final bool active;
  final Color color;
  const _Dot({Key? key, required this.active, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? color : color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
