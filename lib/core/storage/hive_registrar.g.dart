// Generated-style registrar for the standalone DevPlanner storage foundation.

import 'package:hive_ce/hive_ce.dart';
import 'package:flutter/material.dart';
import 'package:devplanner/features/settings/domain/local_settings_model.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(AppLanguageAdapter());
    registerAdapter(AppThemePaletteAdapter());
    registerAdapter(AppThemeSeedColorAdapter());
    registerAdapter(LocalSettingsModelAdapter());
    registerAdapter(ThemeModeAdapter());
  }
}

class LocalSettingsModelAdapter extends TypeAdapter<LocalSettingsModel> {
  @override
  final typeId = 44;

  @override
  LocalSettingsModel read(BinaryReader reader) {
    final fields = <int, dynamic>{
      for (var i = 0, count = reader.readByte(); i < count; i++)
        reader.readByte(): reader.read(),
    };
    return LocalSettingsModel(
      themeMode: fields[0] as ThemeMode,
      themePalette: fields[1] as AppThemePalette,
      themeSeedColor: fields[2] as AppThemeSeedColor,
      language: fields[3] as AppLanguage,
      sideMenuOrders: (fields[4] as Map).map(
        (key, value) => MapEntry(key as String, (value as List).cast<String>()),
      ),
      sideMenuCollapsed: fields[5] == null
          ? const {}
          : (fields[5] as Map).cast<String, bool>(),
      globalChatPinned: fields[6] as bool? ?? false,
      globalChatWidth: (fields[7] as num?)?.toDouble() ?? 384,
      globalChatLastConversationId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalSettingsModel value) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(value.themeMode)
      ..writeByte(1)
      ..write(value.themePalette)
      ..writeByte(2)
      ..write(value.themeSeedColor)
      ..writeByte(3)
      ..write(value.language)
      ..writeByte(4)
      ..write(value.sideMenuOrders)
      ..writeByte(5)
      ..write(value.sideMenuCollapsed)
      ..writeByte(6)
      ..write(value.globalChatPinned)
      ..writeByte(7)
      ..write(value.globalChatWidth)
      ..writeByte(8)
      ..write(value.globalChatLastConversationId);
  }
}

class AppLanguageAdapter extends TypeAdapter<AppLanguage> {
  @override
  final typeId = 47;

  @override
  AppLanguage read(BinaryReader reader) => switch (reader.readByte()) {
    1 => AppLanguage.en,
    _ => AppLanguage.pl,
  };

  @override
  void write(BinaryWriter writer, AppLanguage value) =>
      writer.writeByte(value == AppLanguage.en ? 1 : 0);
}

class AppThemePaletteAdapter extends TypeAdapter<AppThemePalette> {
  @override
  final typeId = 45;

  @override
  AppThemePalette read(BinaryReader reader) => switch (reader.readByte()) {
    1 => AppThemePalette.material,
    _ => AppThemePalette.classic,
  };

  @override
  void write(BinaryWriter writer, AppThemePalette value) =>
      writer.writeByte(value == AppThemePalette.material ? 1 : 0);
}

class AppThemeSeedColorAdapter extends TypeAdapter<AppThemeSeedColor> {
  @override
  final typeId = 46;

  @override
  AppThemeSeedColor read(BinaryReader reader) {
    final values = AppThemeSeedColor.values;
    final index = reader.readByte();
    return index < values.length ? values[index] : values.first;
  }

  @override
  void write(BinaryWriter writer, AppThemeSeedColor value) =>
      writer.writeByte(value.index);
}

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final typeId = 48;

  @override
  ThemeMode read(BinaryReader reader) {
    final values = ThemeMode.values;
    final index = reader.readByte();
    return index < values.length ? values[index] : ThemeMode.system;
  }

  @override
  void write(BinaryWriter writer, ThemeMode value) =>
      writer.writeByte(value.index);
}
