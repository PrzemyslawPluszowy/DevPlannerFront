import 'package:devplanner/foundation/config/app_env.dart';
import 'package:flutter/material.dart';

/// Uniwersalny widżet awatara użytkownika w DevPlanner.
///
/// Obsługuje:
/// - Bezpośrednie pobieranie ze strumieniowego endpointu `/api/v1/users/{userId}/avatar`
///   (lub `/api/v1/me/avatar` dla profilu bieżącego użytkownika).
/// - Bezpieczny fallback na [CircleAvatar] z inicjałami użytkownika (np. "JK" lub pierwsza litera)
///   w przypadku braku zdjęcia, błędu sieciowego lub statusu 404.
/// - Opcjonalną kropkę statusu obecności (online).
/// - Nową składnię Darta dot shorthands oraz pełne wsparcie dostępności i tooltipów.
class AppUserAvatar extends StatefulWidget {
  /// Tworzy instancję awatara użytkownika.
  const AppUserAvatar({
    this.userId,
    this.displayName,
    this.avatarUrl,
    this.isCurrentUser = false,
    this.hasCustomAvatar,
    this.radius = 16.0,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.singleInitial = false,
    this.isOnline,
    this.tooltip,
    this.semanticsLabel,
    this.onTap,
    super.key,
  });

  /// Identyfikator użytkownika (UUID), używany do pobrania `/api/v1/users/{userId}/avatar`.
  final String? userId;

  /// Nazwa wyświetlana użytkownika do generowania inicjałów.
  final String? displayName;

  /// Opcjonalny jawny URL awatara (jeśli podany z zewnętrznego źródła).
  final String? avatarUrl;

  /// Czy awatar dotyczy bieżącego zalogowanego użytkownika (`/api/v1/me/avatar`).
  final bool isCurrentUser;

  /// Opcjonalna flaga informująca, czy profil posiada wgrany awatar (np. avatarFileId != null).
  /// Jeśli jawnie ustawiona na `false`, pomija próbę pobierania z sieci i od razu renderuje inicjały.
  final bool? hasCustomAvatar;

  /// Promień awatara w logicznych pikselach.
  final double radius;

  /// Opcjonalny kolor tła (jeśli brak, wyliczany deterministycznie z identyfikatora/nazwy).
  final Color? backgroundColor;

  /// Opcjonalny kolor tekstu inicjałów.
  final Color? foregroundColor;

  /// Opcjonalny styl tekstu inicjałów.
  final TextStyle? textStyle;

  /// Czy generować tylko jedną literę inicjału (np. dla małych awatarów).
  final bool singleInitial;

  /// Czy użytkownik jest aktualnie online (opcjonalny wskaźnik obecności).
  final bool? isOnline;

  /// Treść etykiety narzędzia (Tooltip).
  final String? tooltip;

  /// Etykieta dostępności dla czytników ekranu.
  final String? semanticsLabel;

  /// Opcjonalne wywołanie zwrotne po kliknięciu.
  final VoidCallback? onTap;

  /// Pomocnicza funkcja wyliczająca inicjały z nazwy wyświetlanej.
  static String extractInitials(String? displayName, {bool single = false, String fallback = '?'}) {
    final name = displayName?.trim();
    if (name == null || name.isEmpty) return fallback;

    if (single) {
      return name.characters.first.toUpperCase();
    }

    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      final first = parts[0].characters.firstOrNull ?? '';
      final second = parts[1].characters.firstOrNull ?? '';
      final initials = '$first$second'.toUpperCase();
      if (initials.isNotEmpty) return initials;
    }

    return name.characters.first.toUpperCase();
  }

  /// Pomocnicza paleta barw deterministycznie przypisywana do użytkowników.
  static Color resolveAvatarColor(String? seed, {ColorScheme? colorScheme}) {
    const palette = <Color>[
      Color(0xFF6C5CE7),
      Color(0xFF0984E3),
      Color(0xFF00A884),
      Color(0xFFE17055),
      Color(0xFFD63031),
      Color(0xFFE84393),
      Color(0xFF2D3436),
      Color(0xFF00CEC9),
    ];
    final clean = seed?.trim() ?? '';
    if (clean.isEmpty) {
      return colorScheme?.primaryContainer ?? palette[0];
    }
    final hash = clean.codeUnits.fold<int>(0, (acc, c) => acc * 31 + c);
    return palette[hash.abs() % palette.length];
  }

  @override
  State<AppUserAvatar> createState() => _AppUserAvatarState();
}

class _AppUserAvatarState extends State<AppUserAvatar> {
  bool _hasError = false;
  String? _resolvedUrl;

  @override
  void initState() {
    super.initState();
    _resolveTargetUrl();
  }

  @override
  void didUpdateWidget(covariant AppUserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId ||
        oldWidget.avatarUrl != widget.avatarUrl ||
        oldWidget.isCurrentUser != widget.isCurrentUser ||
        oldWidget.hasCustomAvatar != widget.hasCustomAvatar) {
      _hasError = false;
      _resolveTargetUrl();
    }
  }

  void _resolveTargetUrl() {
    // Jeżeli profil jawnie deklaruje brak awatara, nie wysyłamy zbędnych zapytań
    if (widget.hasCustomAvatar == false) {
      _resolvedUrl = null;
      return;
    }

    if (widget.isCurrentUser) {
      _resolvedUrl = AppEnv.currentUserAvatarUrl();
      return;
    }

    final explicitUrl = widget.avatarUrl?.trim();
    if (explicitUrl != null && explicitUrl.isNotEmpty) {
      if (explicitUrl.startsWith('http://') || explicitUrl.startsWith('https://')) {
        _resolvedUrl = explicitUrl;
      } else {
        final base = AppEnv.apiBaseUrl.endsWith('/')
            ? AppEnv.apiBaseUrl
            : '${AppEnv.apiBaseUrl}/';
        _resolvedUrl = Uri.parse(base).resolve(explicitUrl).toString();
      }
      return;
    }

    final uid = widget.userId?.trim();
    if (uid != null && uid.isNotEmpty) {
      _resolvedUrl = AppEnv.userAvatarUrl(uid);
      return;
    }

    _resolvedUrl = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = AppUserAvatar.extractInitials(
      widget.displayName,
      single: widget.singleInitial,
    );

    final effectiveBgColor = widget.backgroundColor ??
        AppUserAvatar.resolveAvatarColor(
          widget.userId ?? widget.displayName,
          colorScheme: theme.colorScheme,
        );

    final effectiveFgColor = widget.foregroundColor ?? Colors.white;

    final fontSize = widget.singleInitial
        ? (widget.radius * 0.9).clamp(9.0, 22.0)
        : (widget.radius * 0.75).clamp(10.0, 22.0);

    final effectiveTextStyle = widget.textStyle ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: .w700,
          color: effectiveFgColor,
        );

    Widget avatarCore;

    if (_resolvedUrl != null && !_hasError) {
      avatarCore = CircleAvatar(
        radius: widget.radius,
        backgroundColor: effectiveBgColor,
        backgroundImage: NetworkImage(_resolvedUrl!),
        onBackgroundImageError: (_, _) {
          if (mounted) {
            setState(() {
              _hasError = true;
            });
          }
        },
        child: Text(initials, style: effectiveTextStyle),
      );
    } else {
      avatarCore = CircleAvatar(
        radius: widget.radius,
        backgroundColor: effectiveBgColor,
        child: Text(initials, style: effectiveTextStyle),
      );
    }

    if (widget.isOnline == true) {
      final indicatorSize = (widget.radius * 0.6).clamp(6.0, 14.0);
      avatarCore = Stack(
        clipBehavior: .none,
        children: [
          avatarCore,
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: .circle,
                border: .all(
                  color: theme.colorScheme.surface,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (widget.onTap != null) {
      avatarCore = InkWell(
        onTap: widget.onTap,
        borderRadius: .circular(widget.radius),
        child: avatarCore,
      );
    }

    if (widget.tooltip case final tooltipText? when tooltipText.isNotEmpty) {
      avatarCore = Tooltip(
        message: tooltipText,
        child: avatarCore,
      );
    }

    if (widget.semanticsLabel != null && widget.semanticsLabel!.isNotEmpty) {
      avatarCore = Semantics(
        label: widget.semanticsLabel,
        child: avatarCore,
      );
    }

    return avatarCore;
  }
}
