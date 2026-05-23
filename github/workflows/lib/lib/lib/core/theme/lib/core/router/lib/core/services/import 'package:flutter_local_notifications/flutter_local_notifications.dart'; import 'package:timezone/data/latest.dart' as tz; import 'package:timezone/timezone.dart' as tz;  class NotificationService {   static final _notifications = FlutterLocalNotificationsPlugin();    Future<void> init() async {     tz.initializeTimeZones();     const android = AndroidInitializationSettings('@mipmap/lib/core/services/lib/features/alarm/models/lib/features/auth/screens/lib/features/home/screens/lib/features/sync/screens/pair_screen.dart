import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class PairScreen extends ConsumerStatefulWidget {
  const PairScreen({super.key});
  @override
  ConsumerState<PairScreen> createState() => _PairScreenState();
}

class _PairScreenState extends ConsumerState<PairScreen> {
  final _code = TextEditingController();
  String _myCode = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  Future<void> _generateCode() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final code = const Uuid().v4().substring(0, 6).toUpperCase();
    await FirebaseFirestore.instance.collection('pair_codes').doc(code).set({
      'userId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    setState(() => _myCode = code);
  }

  Future<void> _joinWithCode() async {
    setState(() => _loading = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('pair_codes').doc(_code.text).get();
      if (!doc.exists) throw 'Invalid code';
      
      final partnerId = doc.data()!['userId'];
      final myId = FirebaseAuth.instance.currentUser!.uid;
      
      final batch = FirebaseFirestore.instance.batch();
      batch.update(FirebaseFirestore.instance.collection('users').doc(myId), {'partnerId': partnerId});
      batch.update(FirebaseFirestore.instance.collection('users').doc(partnerId), {'partnerId': myId});
      await batch.commit();
      
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pair failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pair with Partner')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  Text('Your Code', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(_myCode, style: Theme.of(context).textTheme.displayMedium?.copyWith(letterSpacing: 8)),
                  const SizedBox(height: 8),
                  Text('Share this with your partner', style: Theme.of(context).textTheme.bodySmall),
                ]),
              ),
            ),
            const SizedBox(height: 32),
            Text('Or enter their code', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: '6-digit code', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loading? null : _joinWithCode, 
              child: _loading? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Pair')
            ),
          ],
        ),
      ),
    );
  }
}
