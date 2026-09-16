import 'package:flutter/material.dart';

/// Pojedynczy fragment tekstu dla [AppText.rich].
class AppTextPart {
  const AppTextPart({required this.text, this.style});

  final String text;
  final TextStyle? style;
}

/// Minimalny wrapper na `Text` / `Text.rich` / `SelectableText`.
///
/// Pozwala jednym API:
/// - wyswietlic zwykly tekst,
/// - zbudowac rich text z wielu fragmentow,
/// - wlaczyc zaznaczanie (`selectable`) bez przepinania widgetu recznie.
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.selectable = false,
    this.softWrap,
  }) : parts = null;

  const AppText.rich({
    required this.parts,
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.selectable = false,
    this.softWrap,
  }) : text = null;

  final String? text;
  final List<AppTextPart>? parts;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool selectable;
  final bool? softWrap;

  InlineSpan _buildSpan() {
    if (parts case final items?) {
      return TextSpan(
        style: style,
        children: [
          for (final item in items)
            TextSpan(text: item.text, style: item.style),
        ],
      );
    }

    return TextSpan(text: text ?? '', style: style);
  }

  @override
  Widget build(BuildContext context) {
    final span = _buildSpan();

    if (selectable) {
      return SelectableText.rich(
        TextSpan(style: style, children: [span]),
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    return Text.rich(
      TextSpan(style: style, children: [span]),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
