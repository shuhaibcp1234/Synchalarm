import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sync_alarm/features/alarm/models/alarm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAlarmScreen extends ConsumerStatefulWidget {
  final Alarm? alarm;
  const EditAlarmScreen({this.alarm, super.key});

  @override
  ConsumerState<EditAlarmScreen> createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends ConsumerState<EditAlarmScreen> {
  late TimeOfDay _time;
  late String _label;
  late bool _isShared;

  @override
  void initState() {
    super.initState();
    _time = widget.alarm!= null
      ? TimeOfDay(hour: int.parse(widget.alarm!.time.split(':')[0]), minute: int.parse(widget.alarm!.time.split(':')[1]))
        : TimeOfDay.now();
    _label = widget.alarm?.label?? 'Alarm';
    _isShared = widget.alarm?.isShared?? false;
  }

  Future<void> _save() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final alarm = Alarm(
      id: widget.alarm?.id?? '',
      ownerId: uid,
      time: '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
      label: _label,
      isShared: _isShared,
    );
    
    final col = FirebaseFirestore.instance.collection('alarms');
    if (widget.alarm == null) {
      await col.add(alarm.toMap());
    } else {
      await col.doc(alarm.id).update(alarm.toMap());
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.alarm == null? 'Add Alarm' : 'Edit Alarm')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Time'),
            trailing: Text(_time.format(context), style: Theme.of(context).textTheme.headlineSmall),
            onTap: () async {
              final t = await showTimePicker(context: context, initialTime: _time);
              if (t!= null) setState(() => _time = t);
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Label'),
            controller: TextEditingController(text: _label),
            onChanged: (v) => _label = v,
          ),
          SwitchListTile(
            title: const Text('Share with partner'),
            value: _isShared,
            onChanged: (v) => setState(() => _isShared = v),
          ),
          const SizedBox(height: 32),
          FilledButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
