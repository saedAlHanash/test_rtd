import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService instance = RemoteConfigService._();

  late final FirebaseRemoteConfig _rc;

  /// Initialize Firebase and Remote Config.
  /// Call this once before using any getters.
  Future<void> init() async {
    // Ensure Firebase is initialized (in case this is called before main's init).
    await Firebase.initializeApp();
    _rc = FirebaseRemoteConfig.instance;

    // Default values – safe fallbacks.
    await _rc.setDefaults(<String, dynamic>{
      'welcome_message': 'Welcome to Test RTD!',
      'show_new_feature': false,
      'primary_color': '#2196F3',
      'max_items': 10,
    });

    // Settings – fast fetch interval in debug mode.
    final settings = RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: kDebugMode ? const Duration(seconds: 30) : const Duration(hours: 12),
    );
    await _rc.setConfigSettings(settings);
  }

  /// Pull latest values from the server and activate them.
  /// Returns true if new values were activated.
  Future<bool> fetchAndActivate() async {
    try {
      await _rc.fetch();
      return await _rc.activate();
    } on FirebaseException catch (e) {
      debugPrint('Remote Config fetch error: ${e.message}');
      return false;
    }
  }

  // Typed getters ----------------------------------------------------------
  String get welcomeMessage => _rc.getString('welcome_message');

  bool get showNewFeature => _rc.getBool('show_new_feature');

  int get maxItems => _rc.getInt('max_items');

  double get discountRate => _rc.getDouble('discount_rate');

  /// Example JSON‑encoded parameter.
  Map<String, dynamic> get complexConfig {
    final raw = _rc.getString('complex_json');
    try {
      return raw.isNotEmpty ? jsonDecode(raw) as Map<String, dynamic> : {};
    } catch (_) {
      return {};
    }
  }

  /// Listen for config updates while the app is running.
  void addListener(void Function() onUpdated) {
    // _rc.addOnConfigUpdatedListener(onUpdated);
  }
}
