import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String picture;
  final String phone;
  final String nationality;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
    required this.phone,
    required this.nationality,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['login']['uuid'] as String,
      name: '${json['name']['first']} ${json['name']['last']}',
      email: json['email'] as String,
      picture: json['picture']['large'] as String,
      phone: json['phone'] as String,
      nationality: json['nat'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
