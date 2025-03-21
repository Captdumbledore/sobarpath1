// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommunityQuestionAdapter extends TypeAdapter<CommunityQuestion> {
  @override
  final int typeId = 0;

  @override
  CommunityQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommunityQuestion(
      question: fields[0] as String,
      answer: fields[1] as String,
      category: fields[3] as String,
      dateCreated: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CommunityQuestion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.answer)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunityQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
