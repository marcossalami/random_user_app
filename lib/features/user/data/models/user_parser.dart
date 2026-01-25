import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'user_model.dart';

List<UserModel> parseUsers(String responseBody) {
  final decoded = json.decode(responseBody) as Map<String, dynamic>;
  final results = decoded['results'] as List;

  return results.map((json) => UserModel.fromJson(json)).toList();
}

Future<List<UserModel>> parseUsersInBackground(String body) {
  return compute(parseUsers, body);
}
