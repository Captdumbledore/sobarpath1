// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joined_community.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JoinedCommunityAdapter extends TypeAdapter<JoinedCommunity> {
  @override
  final int typeId = 2;

  @override
  JoinedCommunity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JoinedCommunity(
      communityName: fields[0] as String,
      joinedDate: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, JoinedCommunity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.communityName)
      ..writeByte(1)
      ..write(obj.joinedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JoinedCommunityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
