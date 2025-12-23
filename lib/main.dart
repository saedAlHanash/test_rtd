 import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'rtd_service.dart';
import 'dart:ui';
import 'json_generator_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      // designSize: const Size(14440, 972),
      minTextAdapt: true,
      // splitScreenMode: true,
      child: MaterialApp(
        title: 'Presence System Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark),
          scaffoldBackgroundColor: const Color(0xFF1E1E2F),
          textTheme: GoogleFonts.interTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
        ),
        home: const JsonGeneratorPage(),
      ),
    );
  }
}

class PresenceDemoPage extends StatefulWidget {
  const PresenceDemoPage({super.key});

  @override
  State<PresenceDemoPage> createState() => _PresenceDemoPageState();
}

class _PresenceDemoPageState extends State<PresenceDemoPage> {
  final TextEditingController _userIdCtrl = TextEditingController();
  final RtdService _rtdService = RtdService();
  bool _presenceEnabled = false;

  @override
  void dispose() {
    _userIdCtrl.dispose();
    super.dispose();
  }

  void _togglePresence(bool value) {
    final userId = _userIdCtrl.text.trim();
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a User ID first')));
      return;
    }
    setState(() => _presenceEnabled = value);
    if (value) {
      // Start presence tracking for this user
      _rtdService.setupPresenceSystem(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _userIdCtrl.text.trim();
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Presence Tester'), backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A2A3B), Color(0xFF1E1E2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Glass‑morphic card
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _userIdCtrl,
                            decoration: InputDecoration(
                              labelText: 'User ID',
                              hintText: 'e.g. user_123',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Enable Presence'),
                              Switch.adaptive(
                                value: _presenceEnabled,
                                onChanged: _togglePresence,
                                activeColor: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white30),
                          // Live user status stream
                          if (userId.isNotEmpty) ...[
                            const Text('User Status (Live)', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            StreamBuilder<Map<String, dynamic>>(
                              stream: _rtdService.listenToUserStatus(userId),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text('Waiting for data…');
                                }
                                final data = snapshot.data!;
                                final state = data['state'] ?? 'unknown';
                                final lastChanged = data['last_changed'];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text('State: $state'), Text('Last changed: $lastChanged')],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text('Online Users Count', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            StreamBuilder<int>(
                              stream: _rtdService.trackOnlineUsersCount(),
                              builder: (context, snapshot) {
                                final count = snapshot.data ?? 0;
                                return Text('Online users: $count');
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Footer with subtle animation
                Center(
                  child: Text('💡 Test your presence logic in real‑time', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
