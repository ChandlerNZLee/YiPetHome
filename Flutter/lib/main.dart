// lib/main.dart
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash.dart';
import 'page/shop/payment-result.dart';

import 'view-models/payment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: YiPetApp()));
}

class YiPetApp extends StatefulWidget {
  const YiPetApp({super.key});

  @override
  State<YiPetApp> createState() => _YiPetAppState();
}

class _YiPetAppState extends State<YiPetApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      await _handleDeepLink(uri);
    });
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (uri.scheme != 'yipet') {
      return;
    }

    if (uri.host == 'payment' && uri.path == '/success') {
      final sessionId = uri.queryParameters['session_id'];
      debugPrint('Payment success with session_id: $sessionId');

      final prefs = await SharedPreferences.getInstance();
      final amount = prefs.getDouble('order_amount') ?? 0.0;
      final index =
          prefs.getInt('payment_type') ?? PaymentSummaryType.appointment.index;
      final type = PaymentSummaryType.values[index];

      await navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => PaymentResultPage(
            amount: amount,
            paymentMethod: PaymentMethodType.online,
            type: type,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
