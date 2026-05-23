import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_alarm/core/services/auth_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('SyncAlarm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push('/chat'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, ${user?.email?? 'user'}', 
              style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/edit-alarm'),
              icon: const Icon(Icons.add_alarm),
              label: const Text('Add Alarm'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.push('/pair'),
              icon: const Icon(Icons.link),
              label: const Text('Pair with Partner'),
            ),
          ],
        ),
      ),
    );
  }
}
