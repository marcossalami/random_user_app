import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String gender;
  final String email;
  final String phone;

  final NameModel name;
  final PictureModel picture;
  final LocationModel location;

  UserModel({
    required this.gender,
    required this.email,
    required this.phone,
    required this.name,
    required this.picture,
    required this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class NameModel {
  final String title;
  final String first;
  final String last;

  NameModel({required this.title, required this.first, required this.last});

  factory NameModel.fromJson(Map<String, dynamic> json) =>
      _$NameModelFromJson(json);

  Map<String, dynamic> toJson() => _$NameModelToJson(this);
}

@JsonSerializable()
class PictureModel {
  final String large;
  final String thumbnail;

  PictureModel({required this.large, required this.thumbnail});

  factory PictureModel.fromJson(Map<String, dynamic> json) =>
      _$PictureModelFromJson(json);

  Map<String, dynamic> toJson() => _$PictureModelToJson(this);
}

@JsonSerializable()
class LocationModel {
  final String country;
  final String city;

  LocationModel({required this.country, required this.city});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
