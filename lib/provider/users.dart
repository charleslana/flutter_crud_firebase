import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_crud/data/dummy_users.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {
  static const _baseUrl =
      'https://flutter-crud-firebase-f2789-default-rtdb.firebaseio.com/';

  Map<String, User> _items = {...DUMMY_USERS};

  Future<void> getAll() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users.json'),
    );

    if (json.decode(response.body) != null) {
      Map<Object, dynamic> data = json.decode(response.body);

      data.forEach((key, values) {
        _items.putIfAbsent(
          key as String,
          () => User(
            id: key,
            name: values['name'],
            email: values['email'],
            avatarUrl: values['avatarUrl'],
          ),
        );
      });

      notifyListeners();
    }
  }

  int get count {
    return _items.length;
  }

  User byIndex(int index) {
    return _items.values.elementAt(index);
  }

  Future<void> put(User user) async {
    if (user == null) {
      return;
    }

    if (user.id != null &&
        user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      await http.patch(
        Uri.parse('$_baseUrl/users/${user.id}.json'),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl,
        }),
      );

      _items.update(user.id, (_) => user);
    } else {
      final response = await http.post(
        Uri.parse('$_baseUrl/users.json'),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl,
        }),
      );

      final id = json.decode(response.body)['name'];

      _items.putIfAbsent(
        id,
        () => User(
          id: id,
          name: user.name,
          email: user.email,
          avatarUrl: user.avatarUrl,
        ),
      );
    }

    notifyListeners();
  }

  void remove(User user) async {
    if (user != null && user.id != null) {
      await http.delete(
        Uri.parse('$_baseUrl/users/${user.id}.json'),
      );
      _items.remove(user.id);
      notifyListeners();
    }
  }
}
