class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  String? firstName;
  String? lastName;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}