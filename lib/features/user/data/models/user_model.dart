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

  @HiveField(6)
  final String gender;

  @HiveField(7)
  final String cell;

  @HiveField(8)
  final String street;

  @HiveField(9)
  final String city;

  @HiveField(10)
  final String state;

  @HiveField(11)
  final String country;

  @HiveField(12)
  final String postcode;

  @HiveField(13)
  final String dob;

  @HiveField(14)
  final int age;

  @HiveField(15)
  final String registered;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
    required this.phone,
    required this.nationality,
    required this.gender,
    required this.cell,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
    required this.dob,
    required this.age,
    required this.registered,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['login']['uuid'] as String,
      name: '${json['name']['first']} ${json['name']['last']}',
      email: json['email'] as String,
      picture: json['picture']['large'] as String,
      phone: json['phone'] as String,
      nationality: json['nat'] as String,
      gender: json['gender'] as String,
      cell: json['cell'] as String,
      street:
          '${json['location']['street']['number']} ${json['location']['street']['name']}',
      city: json['location']['city'] as String,
      state: json['location']['state'] as String,
      country: json['location']['country'] as String,
      postcode: json['location']['postcode'].toString(),
      dob: json['dob']['date'] as String,
      age: json['dob']['age'] as int,
      registered: json['registered']['date'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
