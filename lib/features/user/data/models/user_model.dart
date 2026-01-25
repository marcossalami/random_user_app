import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String picture;

  @HiveField(4)
  final String phone;

  @HiveField(5)
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
