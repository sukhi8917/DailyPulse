import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood_entry.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveEntry(String uid, MoodEntry entry) async {
    final ref = _firestore
        .collection('users')
        .doc(uid)
        .collection('moodEntries')
        .doc(entry.id);

    await ref.set(entry.toMap());
  }

  Future<List<MoodEntry>> loadEntries(String uid) async {
    final snap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('moodEntries')
        .orderBy('date', descending: true)
        .get();

    return snap.docs.map((d) => MoodEntry.fromMap(d.data())).toList();
  }
}
