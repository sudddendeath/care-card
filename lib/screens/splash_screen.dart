import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_model.dart';
import 'login_screen.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthModel _auth;
  Timer? _timeout;
  bool _navigated = false;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    // We'll access AuthModel in didChangeDependencies because provider isn't
    // available during initState.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthModel>(context, listen: false);

    // Register a listener so we can react when AuthModel finishes
    // initialization (isInitialized) or when auth state changes.
    _listener = () {
      if (_auth.isInitialized && !_navigated) {
        _decideNavigation();
      }
    };
    _auth.addListener(_listener);

    // If auth state is already known, schedule a navigation check on the
    // next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_auth.isInitialized && !_navigated) _decideNavigation();
    });

    // As a safety, set a timeout so we don't wait forever.
    _timeout = Timer(const Duration(seconds: 5), () {
      if (!_navigated) _decideNavigation();
    });
  }

  void _decideNavigation() {
    if (_navigated) return;
    _navigated = true;

    if (_auth.isAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _auth.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('Care Card', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
