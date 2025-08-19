import 'package:flutter/material.dart';
import '../../infrastructure/di/locator.dart';
import '../../infrastructure/auth/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _loading = false;

  void _show(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _resend() async {
    setState(() => _loading = true);
    final auth = locator<AuthService>();
    try {
      await auth.sendEmailVerification();
      _show('Verification email sent');
    } on AuthException catch (e) {
      _show('${e.message} (${e.code})');
    } catch (e) {
      _show(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final auth = locator<AuthService>();
    try {
      final user = await auth.reloadUser();
      if (user != null && user.emailVerified) {
        if (!mounted) return;
        Navigator.of(context).pop(); // go back to gate
      } else {
        _show('Not verified yet. Please check your email.');
      }
    } on AuthException catch (e) {
      _show('${e.message} (${e.code})');
    } catch (e) {
      _show(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'We emailed you a verification link. Please verify your email to continue.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: _loading ? null : _resend,
                      child: const Text('Resend'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _loading ? null : _refresh,
                      child: const Text('I have verified'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
