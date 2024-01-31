import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qwitravel/providers/database_provider.dart';
import 'package:qwitravel/theme/colors/accent.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';

enum Pages { home, grades, timetable, messages, absences }

enum UpdateChannel { stable, beta, dev }

enum VibrationStrength { off, light, medium, strong }

class SettingsProvider extends ChangeNotifier {
  final DatabaseProvider? _database;

  // en_en, hu_hu, de_de
  String _language;
  Pages _startPage;
  ThemeMode _theme;
  AccentColor _accentColor;
  bool _newsEnabled;
  String _seenNews;
  bool _developerMode;
  Config _config;
  String _xQwId;
  Color _customAccentColor;
  String _lastAccountId;

  SettingsProvider({
    DatabaseProvider? database,
    required String language,
    required Pages startPage,
    required ThemeMode theme,
    required AccentColor accentColor,
    required bool newsEnabled,
    required String seenNews,
    required bool developerMode,
    required Config config,
    required String xQwId,
    required Color customAccentColor,
    required String lastAccountId,
  })  : _database = database,
        _language = language,
        _startPage = startPage,
        _theme = theme,
        _accentColor = accentColor,
        _newsEnabled = newsEnabled,
        _seenNews = seenNews,
        _developerMode = developerMode,
        _config = config,
        _xQwId = xQwId,
        _customAccentColor = customAccentColor,
        _lastAccountId = lastAccountId;

  factory SettingsProvider.fromMap(Map map,
      {required DatabaseProvider database}) {
    Map<String, Object?>? configMap;

    try {
      configMap = jsonDecode(map["config"] ?? "{}");
    } catch (e) {
      log("[ERROR] SettingsProvider.fromMap: $e");
    }

    return SettingsProvider(
      database: database,
      language: map["language"],
      startPage: Pages.values[map["start_page"]],
      theme: ThemeMode.values[map["theme"]],
      accentColor: AccentColor.values[map["accent_color"]],
      newsEnabled: map["news"] == 1,
      seenNews: map["seen_news"],
      developerMode: map["developer_mode"] == 1,
      config: Config.fromJson(configMap ?? {}),
      xQwId: map["x_filc_id"],
      customAccentColor: Color(map["custom_accent_color"]),
      lastAccountId: map["last_account_id"],
    );
  }

  Map<String, Object?> toMap() {
    return {
      "language": _language,
      "start_page": _startPage.index,
      "theme": _theme.index,
      "accent_color": _accentColor.index,
      "news": _newsEnabled ? 1 : 0,
      "seen_news": _seenNews,
      "developer_mode": _developerMode ? 1 : 0,
      "config": jsonEncode(config.json),
      "x_filc_id": _xQwId,
      "custom_accent_color": _customAccentColor.value,
      "last_account_id": _lastAccountId,
    };
  }

  factory SettingsProvider.defaultSettings({DatabaseProvider? database}) {
    return SettingsProvider(
      database: database,
      language: "hu",
      startPage: Pages.home,
      theme: ThemeMode.system,
      accentColor: AccentColor.qwit,
      newsEnabled: true,
      seenNews: '',
      developerMode: false,
      config: Config.fromJson({}),
      xQwId: const Uuid().v4(),
      customAccentColor: const Color(0xff9E00FF),
      lastAccountId: "",
    );
  }

  // Getters
  String get language => _language;
  Pages get startPage => _startPage;
  ThemeMode get theme => _theme;
  AccentColor get accentColor => _accentColor;
  bool get newsEnabled => _newsEnabled;
  List<String> get seenNews => _seenNews.split(',');
  bool get developerMode => _developerMode;
  Config get config => _config;
  String get xFilcId => _xQwId;
  Color? get customAccentColor =>
      _customAccentColor == accentColorMap[AccentColor.custom]
          ? null
          : _customAccentColor;
  String get lastAccountId => _lastAccountId;

  Future<void> update({
    bool store = true,
    String? language,
    Pages? startPage,
    ThemeMode? theme,
    AccentColor? accentColor,
    bool? newsEnabled,
    String? seenNewsId,
    bool? developerMode,
    Config? config,
    String? xQwId,
    Color? customAccentColor,
    String? lastAccountId,
  }) async {
    if (language != null && language != _language) _language = language;
    if (startPage != null && startPage != _startPage) _startPage = startPage;

    if (theme != null && theme != _theme) _theme = theme;
    if (accentColor != null && accentColor != _accentColor) {
      _accentColor = accentColor;
    }

    if (newsEnabled != null && newsEnabled != _newsEnabled) {
      _newsEnabled = newsEnabled;
    }
    if (seenNewsId != null && !_seenNews.split(',').contains(seenNewsId)) {
      var tempList = _seenNews.split(',');
      tempList.add(seenNewsId);
      _seenNews = tempList.join(',');
    }

    if (developerMode != null && developerMode != _developerMode) {
      _developerMode = developerMode;
    }

    if (config != null && config != _config) _config = config;
    if (xQwId != null && xQwId != _xQwId) _xQwId = xQwId;

    if (customAccentColor != null && customAccentColor != _customAccentColor) {
      _customAccentColor = customAccentColor;
    }

    if (lastAccountId != null && lastAccountId != _lastAccountId) {
      _lastAccountId = lastAccountId;
    }

    // store or not
    if (store) await _database?.store.storeSettings(this);
    notifyListeners();
  }
}
