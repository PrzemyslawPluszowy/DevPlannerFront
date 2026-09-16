import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';
import 'package:ready_next/shared/presentation/widgets/app_overlay_route_lifecycle.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';

/// Pojedyncza opcja dla [AppSearchDropdown].
class AppSearchDropdownOption<T> {
  const AppSearchDropdownOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.keywords = const [],
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final List<String> keywords;
  final bool enabled;
}

/// Kompaktowy `search dropdown` oparty o kontrolowany panel wynikow.
///
/// Uzycie:
/// - wpisujesz zapytanie,
/// - lista renderuje sie w stabilnym overlay bez `SearchAnchor`,
/// - wybierasz element z propozycji.
class AppSearchDropdown<T> extends StatefulWidget {
  const AppSearchDropdown({
    required this.options,
    required this.onSelected,
    super.key,
    this.searchController,
    this.hintText = 'Szukaj...',
    this.noResultsText = 'Brak wyników',
    this.width,
    this.viewMaxHeight = 280,
    this.size = AppControlSize.small,
    this.debounce = const Duration(milliseconds: 250),
    this.onChanged,
    this.onChangedDebounced,
    this.closeWithSelectedLabel = true,
    this.isLoading = false,
    this.loadingText = 'Trwa wyszukiwanie...',
    this.showLoadingInSuggestions = true,
  });

  final List<AppSearchDropdownOption<T>> options;
  final ValueChanged<AppSearchDropdownOption<T>> onSelected;
  final SearchController? searchController;
  final String hintText;
  final String noResultsText;
  final double? width;
  final double viewMaxHeight;
  final AppControlSize size;
  final Duration debounce;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onChangedDebounced;
  final bool closeWithSelectedLabel;
  final bool isLoading;
  final String loadingText;
  final bool showLoadingInSuggestions;

  @override
  State<AppSearchDropdown<T>> createState() => _AppSearchDropdownState<T>();
}

/// Stan kontrolowanego dropdowna wyszukiwarki.
class _AppSearchDropdownState<T> extends State<AppSearchDropdown<T>>
    with WidgetsBindingObserver {
  late final SearchController _internalController;
  late final FocusNode _focusNode;
  final GlobalKey _fieldKey = GlobalKey();
  final Object _tapRegionGroup = Object();
  OverlayEntry? _overlayEntry;
  AppOverlayRouteLifecycle? _routeLifecycle;
  Timer? _debounceTimer;
  var _isOpen = false;
  var _isLifecycleClosed = false;

  SearchController get _controller =>
      widget.searchController ?? _internalController;

  SearchController _controllerFor(AppSearchDropdown<T> widget) =>
      widget.searchController ?? _internalController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _internalController = SearchController();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AppSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = _controllerFor(oldWidget);
    final nextController = _controller;
    if (!identical(oldController, nextController)) {
      oldController.removeListener(_handleControllerChanged);
      nextController.addListener(_handleControllerChanged);
    }
    _scheduleOverlaySync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextLifecycle = AppOverlayRouteLifecycleScope.maybeOf(context);
    if (identical(_routeLifecycle, nextLifecycle)) {
      return;
    }
    _routeLifecycle?.removeListener(_closeForRouteChange);
    _routeLifecycle = nextLifecycle;
    _routeLifecycle?.addListener(_closeForRouteChange);
  }

  @override
  void didChangeMetrics() {
    _closeOverlayForAnchorChange();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _routeLifecycle?.removeListener(_closeForRouteChange);
    _debounceTimer?.cancel();
    _removeOverlay();
    _controller.removeListener(_handleControllerChanged);
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    _internalController.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    _syncOverlay();
    setState(() {});
  }

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }
    if (_focusNode.hasFocus) {
      _isLifecycleClosed = false;
      _setOpen(true);
    }
  }

  void _handleChanged(String query) {
    _isLifecycleClosed = false;
    if (!_isOpen) {
      _setOpen(true);
    }
    widget.onChanged?.call(query);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce, () {
      widget.onChangedDebounced?.call(query);
    });
  }

  void _setOpen(bool value) {
    if (_isOpen == value) {
      _syncOverlay();
      return;
    }
    setState(() => _isOpen = value);
  }

  void _syncOverlay() {
    if (!mounted) {
      return;
    }
    final shouldShowPanel =
        !_isLifecycleClosed && (_isOpen || widget.isLoading);
    if (shouldShowPanel && _fieldRect() == null) {
      if (_overlayEntry != null) {
        _closeOverlayForAnchorChange();
      }
      return;
    }
    if (shouldShowPanel) {
      if (_overlayEntry == null) {
        _overlayEntry = OverlayEntry(builder: _buildOverlay);
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        _overlayEntry?.markNeedsBuild();
      }
    } else {
      _removeOverlay();
    }
  }

  void _scheduleOverlaySync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _syncOverlay();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Zamyka panel przy każdej zmianie trasy private shella.
  void _closeForRouteChange() {
    if (!mounted) {
      return;
    }
    _isLifecycleClosed = true;
    _focusNode.unfocus();
    _setOpen(false);
  }

  /// Po resize lub utracie renderowanej kotwicy overlay nie może pozostać sam.
  void _closeOverlayForAnchorChange() {
    if (!mounted) {
      return;
    }
    _isLifecycleClosed = true;
    _focusNode.unfocus();
    _setOpen(false);
  }

  List<AppSearchDropdownOption<T>> _filterOptions(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return widget.options.where((option) => option.enabled).toList();
    }

    return widget.options.where((option) => option.enabled).where((option) {
      final inLabel = option.label.toLowerCase().contains(normalized);
      final inSubtitle =
          option.subtitle?.toLowerCase().contains(normalized) ?? false;
      final inKeywords = option.keywords.any(
        (keyword) => keyword.toLowerCase().contains(normalized),
      );
      return inLabel || inSubtitle || inKeywords;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveSize = widget.size;
    final minFieldHeight = effectiveSize.minHeight;
    final horizontalPadding = effectiveSize.horizontalPadding;
    const isFilled = false;
    _scheduleOverlaySync();

    final field = TapRegion(
      groupId: _tapRegionGroup,
      onTapOutside: (_) {
        if (!mounted) {
          return;
        }
        _focusNode.unfocus();
        _setOpen(false);
      },
      child: SizedBox(
        key: _fieldKey,
        height: minFieldHeight,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _handleChanged,
          textAlignVertical: .center,
          style: context.text.bodyMedium?.copyWith(
            color: colors.onSurface,
            fontWeight: .w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: context.text.bodyMedium?.copyWith(
              color: context.formControlHintColor,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: effectiveSize.iconSize,
              color: colors.onSurfaceVariant,
            ),
            suffixIcon: widget.isLoading
                ? const Padding(
                    padding: .all(Sizes.p10),
                    child: AppSpinner(
                      strokeWidth: 2,
                    ),
                  )
                : _controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Wyczysc',
                    icon: Icon(
                      Icons.close_rounded,
                      size: effectiveSize.iconSize,
                    ),
                    onPressed: () {
                      _controller.clear();
                      _handleChanged('');
                      _focusNode.requestFocus();
                    },
                  ),
            filled: true,
            fillColor: context.formControlFillColor(isFilled: isFilled),
            contentPadding: .symmetric(
              horizontal: horizontalPadding,
              vertical: effectiveSize.verticalPadding,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
              borderSide: BorderSide(
                color: context.formControlEnabledBorderColor(
                  isFilled: isFilled,
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
              borderSide: BorderSide(color: colors.primary, width: 1.4),
            ),
          ),
        ),
      ),
    );

    if (widget.width case final width?) {
      return SizedBox(width: width, child: field);
    }

    return field;
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final rect = _fieldRect();
    final overlaySize = _overlaySize();
    if (rect == null || overlaySize == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _fieldRect() == null) {
          _closeOverlayForAnchorChange();
        }
      });
      return const SizedBox.shrink();
    }

    final width = math.min<double>(
      widget.width ?? rect.width,
      math.max(120, overlaySize.width - Sizes.p16),
    );
    final maxLeft = math.max(Sizes.p8, overlaySize.width - width - Sizes.p8);
    final left = rect.left.clamp(Sizes.p8, maxLeft);
    final top = rect.bottom + Sizes.p4;
    final availableBelow = overlaySize.height - top - Sizes.p8;
    final maxHeight = math.min<double>(
      widget.viewMaxHeight,
      math.max(80, availableBelow),
    );

    return Positioned(
      left: left,
      top: top,
      width: width,
      child: TapRegion(
        groupId: _tapRegionGroup,
        child: _AppSearchDropdownPanel<T>(
          matches: _filterOptions(_controller.text),
          isLoading: widget.isLoading,
          loadingText: widget.loadingText,
          noResultsText: widget.noResultsText,
          viewMaxHeight: maxHeight,
          size: widget.size,
          showLoadingInSuggestions: widget.showLoadingInSuggestions,
          onSelected: (option) {
            widget.onSelected(option);
            if (widget.closeWithSelectedLabel) {
              _controller.text = option.label;
            } else {
              _controller.clear();
            }
            _focusNode.unfocus();
            _setOpen(false);
          },
        ),
      ),
    );
  }

  Rect? _fieldRect() {
    final fieldBox = _fieldKey.currentContext?.findRenderObject();
    final overlayBox = Overlay.of(context).context.findRenderObject();
    if (fieldBox is! RenderBox ||
        !fieldBox.hasSize ||
        !fieldBox.attached ||
        overlayBox is! RenderBox ||
        !overlayBox.hasSize ||
        !overlayBox.attached) {
      return null;
    }

    final offset = fieldBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    return offset & fieldBox.size;
  }

  Size? _overlaySize() {
    final overlayBox = Overlay.of(context).context.findRenderObject();
    if (overlayBox is RenderBox && overlayBox.hasSize) {
      return overlayBox.size;
    }
    return null;
  }
}

/// Panel wynikow wyszukiwarki.
class _AppSearchDropdownPanel<T> extends StatelessWidget {
  /// Tworzy panel wynikow wyszukiwarki.
  const _AppSearchDropdownPanel({
    required this.matches,
    required this.isLoading,
    required this.loadingText,
    required this.noResultsText,
    required this.viewMaxHeight,
    required this.size,
    required this.showLoadingInSuggestions,
    required this.onSelected,
  });

  final List<AppSearchDropdownOption<T>> matches;
  final bool isLoading;
  final String loadingText;
  final String noResultsText;
  final double viewMaxHeight;
  final AppControlSize size;
  final bool showLoadingInSuggestions;
  final ValueChanged<AppSearchDropdownOption<T>> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      elevation: 4,
      color: colors.surfaceContainerLowest,
      borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
      clipBehavior: .antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: viewMaxHeight),
        child: ListView(
          padding: .zero,
          shrinkWrap: true,
          children: [
            if (isLoading && (matches.isEmpty || showLoadingInSuggestions))
              _AppSearchDropdownStatusTile(
                icon: SizedBox.square(
                  dimension: size.iconSize,
                  child: const AppSpinner(strokeWidth: 2),
                ),
                label: loadingText,
                size: size,
              ),
            if (!isLoading && matches.isEmpty)
              _AppSearchDropdownStatusTile(
                icon: Icon(
                  Icons.search_off_rounded,
                  size: size.iconSize,
                  color: colors.onSurfaceVariant,
                ),
                label: noResultsText,
                size: size,
              ),
            for (final option in matches)
              ListTile(
                dense: true,
                visualDensity: .compact,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size.horizontalPadding,
                ),
                leading: option.icon == null
                    ? null
                    : Icon(
                        option.icon,
                        size: size.iconSize,
                        color: colors.onSurfaceVariant,
                      ),
                title: Text(
                  option.label,
                  style: context.text.bodyMedium?.copyWith(fontWeight: .w500),
                ),
                subtitle: option.subtitle == null
                    ? null
                    : Text(
                        option.subtitle!,
                        style: context.text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                onTap: () => onSelected(option),
              ),
          ],
        ),
      ),
    );
  }
}

/// Wiersz informacyjny panelu wyszukiwarki.
class _AppSearchDropdownStatusTile extends StatelessWidget {
  /// Tworzy wiersz informacyjny panelu wyszukiwarki.
  const _AppSearchDropdownStatusTile({
    required this.icon,
    required this.label,
    required this.size,
  });

  final Widget icon;
  final String label;
  final AppControlSize size;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: .compact,
      contentPadding: EdgeInsets.symmetric(horizontal: size.horizontalPadding),
      leading: icon,
      title: Text(
        label,
        style: context.text.bodyMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
