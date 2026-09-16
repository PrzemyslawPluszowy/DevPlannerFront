// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_helper.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class DashboardPreferencesAdapter extends TypeAdapter<DashboardPreferences> {
  @override
  final typeId = 41;

  @override
  DashboardPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardPreferences(
      readyUserId: fields[0] as String,
      selectedWallpaperPath: fields[1] as String,
      builtInWallpaperPaths: (fields[2] as List).cast<String>(),
      customWallpaperPaths: (fields[3] as List).cast<String>(),
      widgets: (fields[4] as List).cast<DashboardWidgetPreference>(),
      shortcuts: (fields[5] as List).cast<DashboardShortcutPreference>(),
      startupModule: fields[7] as DashboardStartupModule,
      snapToGrid: fields[9] == null ? true : fields[9] as bool,
      desktopGridVersion: (fields[8] as num).toInt(),
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardPreferences obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.readyUserId)
      ..writeByte(1)
      ..write(obj.selectedWallpaperPath)
      ..writeByte(2)
      ..write(obj.builtInWallpaperPaths)
      ..writeByte(3)
      ..write(obj.customWallpaperPaths)
      ..writeByte(4)
      ..write(obj.widgets)
      ..writeByte(5)
      ..write(obj.shortcuts)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.startupModule)
      ..writeByte(8)
      ..write(obj.desktopGridVersion)
      ..writeByte(9)
      ..write(obj.snapToGrid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DashboardShortcutPreferenceAdapter
    extends TypeAdapter<DashboardShortcutPreference> {
  @override
  final typeId = 42;

  @override
  DashboardShortcutPreference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardShortcutPreference(
      shortcutId: fields[0] as String,
      userLabel: fields[1] as String?,
      isVisible: fields[2] as bool,
      position: (fields[3] as num).toInt(),
      gridColumn: (fields[4] as num).toInt(),
      gridRow: (fields[5] as num).toInt(),
      exactDx: (fields[6] as num?)?.toDouble(),
      exactDy: (fields[7] as num?)?.toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, DashboardShortcutPreference obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.shortcutId)
      ..writeByte(1)
      ..write(obj.userLabel)
      ..writeByte(2)
      ..write(obj.isVisible)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.gridColumn)
      ..writeByte(5)
      ..write(obj.gridRow)
      ..writeByte(6)
      ..write(obj.exactDx)
      ..writeByte(7)
      ..write(obj.exactDy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardShortcutPreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DashboardWidgetPreferenceAdapter
    extends TypeAdapter<DashboardWidgetPreference> {
  @override
  final typeId = 43;

  @override
  DashboardWidgetPreference read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardWidgetPreference(
      id: fields[0] as String,
      widgetTypeId: fields[1] as String,
      gridColumn: (fields[2] as num).toInt(),
      gridRow: (fields[3] as num).toInt(),
      width: (fields[4] as num).toInt(),
      height: (fields[5] as num).toInt(),
      preferredWidth: (fields[9] as num?)?.toInt(),
      preferredHeight: (fields[10] as num?)?.toInt(),
      exactDx: (fields[7] as num?)?.toDouble(),
      exactDy: (fields[8] as num?)?.toDouble(),
      settings: (fields[6] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, DashboardWidgetPreference obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.widgetTypeId)
      ..writeByte(2)
      ..write(obj.gridColumn)
      ..writeByte(3)
      ..write(obj.gridRow)
      ..writeByte(4)
      ..write(obj.width)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.settings)
      ..writeByte(7)
      ..write(obj.exactDx)
      ..writeByte(8)
      ..write(obj.exactDy)
      ..writeByte(9)
      ..write(obj.preferredWidth)
      ..writeByte(10)
      ..write(obj.preferredHeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardWidgetPreferenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalSettingsModelAdapter extends TypeAdapter<LocalSettingsModel> {
  @override
  final typeId = 44;

  @override
  LocalSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalSettingsModel(
      themeMode: fields[0] as ThemeMode,
      themePalette: fields[1] as AppThemePalette,
      themeSeedColor: fields[2] as AppThemeSeedColor,
      language: fields[3] as AppLanguage,
      sideMenuOrders: (fields[4] as Map).map(
        (dynamic k, dynamic v) =>
            MapEntry(k as String, (v as List).cast<String>()),
      ),
      sideMenuCollapsed: fields[5] == null
          ? const {}
          : (fields[5] as Map).cast<String, bool>(),
      globalChatPinned: fields[6] == null ? false : fields[6] as bool,
      globalChatWidth: fields[7] == null ? 384 : (fields[7] as num).toDouble(),
      globalChatLastConversationId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalSettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.themePalette)
      ..writeByte(2)
      ..write(obj.themeSeedColor)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.sideMenuOrders)
      ..writeByte(5)
      ..write(obj.sideMenuCollapsed)
      ..writeByte(6)
      ..write(obj.globalChatPinned)
      ..writeByte(7)
      ..write(obj.globalChatWidth)
      ..writeByte(8)
      ..write(obj.globalChatLastConversationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemePaletteAdapter extends TypeAdapter<AppThemePalette> {
  @override
  final typeId = 45;

  @override
  AppThemePalette read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemePalette.classic;
      case 1:
        return AppThemePalette.material;
      default:
        return AppThemePalette.classic;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemePalette obj) {
    switch (obj) {
      case AppThemePalette.classic:
        writer.writeByte(0);
      case AppThemePalette.material:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemePaletteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeSeedColorAdapter extends TypeAdapter<AppThemeSeedColor> {
  @override
  final typeId = 46;

  @override
  AppThemeSeedColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeSeedColor.blue;
      case 1:
        return AppThemeSeedColor.emerald;
      case 2:
        return AppThemeSeedColor.amber;
      case 3:
        return AppThemeSeedColor.rose;
      case 4:
        return AppThemeSeedColor.violet;
      case 5:
        return AppThemeSeedColor.teal;
      case 6:
        return AppThemeSeedColor.indigo;
      case 7:
        return AppThemeSeedColor.orange;
      case 8:
        return AppThemeSeedColor.crimson;
      default:
        return AppThemeSeedColor.blue;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeSeedColor obj) {
    switch (obj) {
      case AppThemeSeedColor.blue:
        writer.writeByte(0);
      case AppThemeSeedColor.emerald:
        writer.writeByte(1);
      case AppThemeSeedColor.amber:
        writer.writeByte(2);
      case AppThemeSeedColor.rose:
        writer.writeByte(3);
      case AppThemeSeedColor.violet:
        writer.writeByte(4);
      case AppThemeSeedColor.teal:
        writer.writeByte(5);
      case AppThemeSeedColor.indigo:
        writer.writeByte(6);
      case AppThemeSeedColor.orange:
        writer.writeByte(7);
      case AppThemeSeedColor.crimson:
        writer.writeByte(8);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeSeedColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppLanguageAdapter extends TypeAdapter<AppLanguage> {
  @override
  final typeId = 47;

  @override
  AppLanguage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppLanguage.pl;
      case 1:
        return AppLanguage.en;
      default:
        return AppLanguage.pl;
    }
  }

  @override
  void write(BinaryWriter writer, AppLanguage obj) {
    switch (obj) {
      case AppLanguage.pl:
        writer.writeByte(0);
      case AppLanguage.en:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final typeId = 48;

  @override
  ThemeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    switch (obj) {
      case ThemeMode.system:
        writer.writeByte(0);
      case ThemeMode.light:
        writer.writeByte(1);
      case ThemeMode.dark:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DashboardStartupModuleAdapter
    extends TypeAdapter<DashboardStartupModule> {
  @override
  final typeId = 49;

  @override
  DashboardStartupModule read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DashboardStartupModule.dashboard;
      case 1:
        return DashboardStartupModule.inventory;
      case 2:
        return DashboardStartupModule.bhp;
      case 3:
        return DashboardStartupModule.settings;
      default:
        return DashboardStartupModule.dashboard;
    }
  }

  @override
  void write(BinaryWriter writer, DashboardStartupModule obj) {
    switch (obj) {
      case DashboardStartupModule.dashboard:
        writer.writeByte(0);
      case DashboardStartupModule.inventory:
        writer.writeByte(1);
      case DashboardStartupModule.bhp:
        writer.writeByte(2);
      case DashboardStartupModule.settings:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardStartupModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
