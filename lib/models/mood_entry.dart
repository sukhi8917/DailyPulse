import 'dart:convert';

class MoodEntry {
  String id; // uuid or timestamp string
  DateTime date;
  String emoji; // e.g. "😄"
  String note;
  int score; // e.g. 1..5, where >3 positive, <=3 neutral/negative

  MoodEntry({
    required this.id,
    required this.date,
    required this.emoji,
    required this.note,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'emoji': emoji,
      'note': note,
      'score': score,
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      emoji: map['emoji'] ?? '',
      note: map['note'] ?? '',
      score: map['score']?.toInt() ?? 3,
    );
  }

  String toJson() => json.encode(toMap());

  factory MoodEntry.fromJson(String source) => MoodEntry.fromMap(json.decode(source));
}
