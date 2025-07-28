// lib/record/data/match_record.dart

class MatchRecord {
  final String id; // Unique ID for file naming (e.g., match_001)
  final String configName;
  final String userEmail;
  final DateTime timestamp;
  final List<FormInputData> inputs;

  MatchRecord({
    required this.id,
    required this.configName,
    required this.userEmail,
    required this.timestamp,
    required this.inputs,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'configName': configName,
    'userEmail': userEmail,
    'timestamp': timestamp.toIso8601String(),
    'inputs': inputs.map((e) => e.toJson()).toList(),
  };

  factory MatchRecord.fromJson(Map<String, dynamic> json) => MatchRecord(
    id: json['id'],
    configName: json['configName'],
    userEmail: json['userEmail'],
    timestamp: DateTime.parse(json['timestamp']),
    inputs: (json['inputs'] as List)
        .map((e) => FormInputData.fromJson(e))
        .toList(),
  );
}

class FormInputData {
  final String type; // e.g., "counter", "text", "slider"
  final String name;
  final Map<String, dynamic> data;

  FormInputData({
    required this.type,
    required this.name,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
    'data': data,
  };

  factory FormInputData.fromJson(Map<String, dynamic> json) => FormInputData(
    type: json['type'],
    name: json['name'],
    data: Map<String, dynamic>.from(json['data']),
  );
}
