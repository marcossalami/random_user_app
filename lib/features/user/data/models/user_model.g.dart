// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      picture: fields[3] as String,
      phone: fields[4] as String,
      nationality: fields[5] as String,
      gender: fields[6] as String,
      cell: fields[7] as String,
      street: fields[8] as String,
      city: fields[9] as String,
      state: fields[10] as String,
      country: fields[11] as String,
      postcode: fields[12] as String,
      dob: fields[13] as String,
      age: fields[14] as int,
      registered: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.picture)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.nationality)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.cell)
      ..writeByte(8)
      ..write(obj.street)
      ..writeByte(9)
      ..write(obj.city)
      ..writeByte(10)
      ..write(obj.state)
      ..writeByte(11)
      ..write(obj.country)
      ..writeByte(12)
      ..write(obj.postcode)
      ..writeByte(13)
      ..write(obj.dob)
      ..writeByte(14)
      ..write(obj.age)
      ..writeByte(15)
      ..write(obj.registered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      picture: json['picture'] as String,
      phone: json['phone'] as String,
      nationality: json['nationality'] as String,
      gender: json['gender'] as String,
      cell: json['cell'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      postcode: json['postcode'] as String,
      dob: json['dob'] as String,
      age: (json['age'] as num).toInt(),
      registered: json['registered'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'picture': instance.picture,
      'phone': instance.phone,
      'nationality': instance.nationality,
      'gender': instance.gender,
      'cell': instance.cell,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postcode': instance.postcode,
      'dob': instance.dob,
      'age': instance.age,
      'registered': instance.registered,
    };
