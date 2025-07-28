
enum FormType {
  counter,
  number,
  lever,
  text,
  checkbox,
  radio,
  dropdown,
  slider,
  date,
  time,
  stopwatch,
  grid,
}

class FormConfig {
  final FormType type;
  final String label;
  final Map<String, dynamic> extraParams;

  FormConfig({
    required this.type,
    required this.label,
    required this.extraParams,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'label': label,
      'extraParams': extraParams,
    };
  }

  static FormConfig fromJson(Map<String, dynamic> json) {
    return FormConfig(
      type: FormType.values.firstWhere((e) => e.name == json['type']),
      label: json['label'],
      extraParams: Map<String, dynamic>.from(json['extraParams']),
    );
  }
}
