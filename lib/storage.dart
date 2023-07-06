import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class Storage {
  static final Storage _singleton = Storage._internal();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  factory Storage() {
    return _singleton;
  }

  Storage._internal();

  saveToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('token') ?? '';
  }
}
