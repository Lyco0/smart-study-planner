// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedPlanAdapter extends TypeAdapter<SavedPlan> {
  @override
  final int typeId = 0;

  @override
  SavedPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedPlan(
      name: fields[0] as String,
      subject: fields[1] as String,
      topics: (fields[2] as List).cast<String>(),
      planMarkdown: fields[3] as String,
      timeRange: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedPlan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.topics)
      ..writeByte(3)
      ..write(obj.planMarkdown)
      ..writeByte(4)
      ..write(obj.timeRange);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
