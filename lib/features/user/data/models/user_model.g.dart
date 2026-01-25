// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  gender: json['gender'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  name: NameModel.fromJson(json['name'] as Map<String, dynamic>),
  picture: PictureModel.fromJson(json['picture'] as Map<String, dynamic>),
  location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'gender': instance.gender,
  'email': instance.email,
  'phone': instance.phone,
  'name': instance.name,
  'picture': instance.picture,
  'location': instance.location,
};

NameModel _$NameModelFromJson(Map<String, dynamic> json) => NameModel(
  title: json['title'] as String,
  first: json['first'] as String,
  last: json['last'] as String,
);

Map<String, dynamic> _$NameModelToJson(NameModel instance) => <String, dynamic>{
  'title': instance.title,
  'first': instance.first,
  'last': instance.last,
};

PictureModel _$PictureModelFromJson(Map<String, dynamic> json) => PictureModel(
  large: json['large'] as String,
  thumbnail: json['thumbnail'] as String,
);

Map<String, dynamic> _$PictureModelToJson(PictureModel instance) =>
    <String, dynamic>{'large': instance.large, 'thumbnail': instance.thumbnail};

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      country: json['country'] as String,
      city: json['city'] as String,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{'country': instance.country, 'city': instance.city};
