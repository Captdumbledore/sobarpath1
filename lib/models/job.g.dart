// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 4;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job(
      id: fields[0] as String,
      title: fields[1] as String,
      company: fields[2] as String,
      salary: fields[3] as String,
      type: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.company)
      ..writeByte(3)
      ..write(obj.salary)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
