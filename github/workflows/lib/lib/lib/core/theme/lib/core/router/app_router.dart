import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sync_alarm/features/auth/screens/login_screen.dart';
import 'package:sync_alarm/features/home/screens/home_screen.dart';
import 'package:sync_alarm/features/sync/screens/pair_screen.dart';
import 'package:sync_alarm/features/alarm/screens/edit_alarm_screen.dart';
import 'package:sync_alarm/features/alarm/screens/ringing_screen.dart';
import 'package:sync_alarm/features/chat/screens/chat_screen.dart';
import 'package:sync_alarm/features/settings/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.matchedLocation == '/login';
      if (user == null) return loggingIn? null : '/login';
      if (loggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/pair', builder: (_, __) => const PairScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/edit-alarm', builder: (_, state) => EditAlarmScreen(alarm: state.extra)),
      GoRoute(path: '/ringing', builder: (_, state) => RingingScreen(label: state.extra as String)),
      GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
});
