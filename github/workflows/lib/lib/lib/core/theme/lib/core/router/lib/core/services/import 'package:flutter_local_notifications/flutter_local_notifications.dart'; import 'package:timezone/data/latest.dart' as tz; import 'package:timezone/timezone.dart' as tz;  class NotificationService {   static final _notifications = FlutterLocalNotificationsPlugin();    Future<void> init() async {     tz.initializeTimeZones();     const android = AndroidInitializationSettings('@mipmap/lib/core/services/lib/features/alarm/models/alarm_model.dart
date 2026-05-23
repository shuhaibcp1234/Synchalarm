import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
  final String id;
  final String ownerId;
  final String time; // "07:30"
  final String label;
  final List<int> days; // 1=Mon, 7=Sun
  final bool isShared;
  final bool isActive;
  final bool vibrate;

  Alarm({
    required this.id,
    required this.ownerId,
    required this.time,
    this.label = 'Alarm',
    this.days = const [],
    this.isShared = false,
    this.isActive = true,
    this.vibrate = true,
  });

  factory Alarm.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Alarm(
      id: doc.id,
      ownerId: data['ownerId'],
      time: data['time'],
      label: data['label']?? 'Alarm',
      days: List<int>.from(data['days']?? []),
      isShared: data['isShared']?? false,
      isActive: data['isActive']?? true,
      vibrate: data['vibrate']?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'ownerId': ownerId,
    'time': time,
    'label': label,
    'days': days,
    'isShared': isShared,
    'isActive': isActive,
    'vibrate': vibrate,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
