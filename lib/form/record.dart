import 'package:frc_scout_app/form/form_config.dart';

class Record {
  final String id; // unique identifier
  final String name; // user-friendly name (can be temp name)
  final List<FormConfig> configSnapshot;
  final Map<String, dynamic> data; // form label -> value
  final int? matchNumber;
  final int? robotNumber;
  final String? alliance; // "red" or "blue"
  final String userName;
  final String userEmail;
  final bool isDraft; // true if unfinished record

  Record({
    required this.id,
    required this.name,
    required this.configSnapshot,
    required this.data,
    this.matchNumber,
    this.robotNumber,
    this.alliance,
    required this.userName,
    required this.userEmail,
    this.isDraft = true,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      name: json['name'],
      configSnapshot: (json['configSnapshot'] as List)
          .map((e) => FormConfig.fromJson(e))
          .toList(),
      data: Map<String, dynamic>.from(json['data']),
      matchNumber: json['matchNumber'],
      robotNumber: json['robotNumber'],
      alliance: json['alliance'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      isDraft: json['isDraft'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'configSnapshot': configSnapshot.map((c) => c.toJson()).toList(),
        'data': data,
        'matchNumber': matchNumber,
        'robotNumber': robotNumber,
        'alliance': alliance,
        'userName': userName,
        'userEmail': userEmail,
        'isDraft': isDraft,
      };
}
