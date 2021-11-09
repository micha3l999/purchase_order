class UserInstance {
  late String name;
  late String code;

  static UserInstance? _userInstance;

  static UserInstance getInstance([String? name, String? code]) {
    _userInstance ??= UserInstance()
      ..code = code!
      ..name = name!;
    return _userInstance!;
  }
}
