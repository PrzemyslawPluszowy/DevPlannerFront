import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Wspólna powierzchnia wejścia do aplikacji, spójna z ramą desktopową.
final class AuthPageSurface extends StatefulWidget {
  const AuthPageSurface({required this.child, super.key});

  final Widget child;

  @override
  State<AuthPageSurface> createState() => _AuthPageSurfaceState();
}

final class _AuthPageSurfaceState extends State<AuthPageSurface> {
  late final ThemeData _light;
  late final ThemeData _dark;

  @override
  void initState() {
    super.initState();
    final theme = MaterialTheme.crm();
    _light = theme.light();
    _dark = theme.dark();
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? _dark
        : _light,
    child: _AuthPageContent(child: widget.child),
  );
}

final class _AuthPageContent extends StatelessWidget {
  const _AuthPageContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shell =
        theme.extension<DevPlannerShellTheme>() ?? DevPlannerShellTheme.light();
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: DevPlannerShellTheme.backdropImage,
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 850;
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(wide ? 48 : 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColoredBox(
                      color: shell.contentSurface,
                      child: wide
                          ? Row(
                              children: [
                                Expanded(child: _AuthBrand(shell: shell)),
                                Expanded(child: child),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _AuthBrand(shell: shell, compact: true),
                                child,
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _AuthBrand extends StatelessWidget {
  const _AuthBrand({required this.shell, this.compact = false});

  final DevPlannerShellTheme shell;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 28 : 48),
      color: shell.backdropStart,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: compact ? 220 : 330,
            semanticLabel: 'BANKAI flow',
          ),
          SizedBox(height: compact ? 24 : 54),
          Text(
            context.l10n.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: shell.sidebarText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.loginSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: shell.sidebarText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
