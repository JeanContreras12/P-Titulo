import 'package:flutter/cupertino.dart';
import 'package:riesgo/models/user.dart';
import 'package:riesgo/widgets/reutilizable.dart';

class Userprovider with ChangeNotifier {
  User? _user;
  final MetodosdeAuth _authMethods = MetodosdeAuth();
  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
