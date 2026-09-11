import 'package:flutter/material.dart';

/// Utility functions for common text manipulation and formatting.
class TextUtils {
  /// Truncates text to a maximum number of lines with ellipsis.
  static Widget truncateToLines({
    required String text,
    required int maxLines,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool softWrap = true,
  }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textAlign: textAlign,
      style: style,
    );
  }

  /// Creates a text span with common styling.
  static TextSpan styledSpan({
    required String text,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextSpan(
      text: text,
      style: style,
    );
  }

  /// Extracts initials from a full name.
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  /// Capitalizes the first letter of each word.
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Capitalizes only the first letter of the text.
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  /// Truncates text to a maximum length with ellipsis.
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Removes extra whitespace from text.
  static String normalizeWhitespace(String text) {
    return text.trim().replaceAll(RegExp(r'\\s+'), ' ');
  }

  /// Checks if text is empty or contains only whitespace.
  static bool isBlank(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Formats text with bold prefix and regular suffix.
  static InlineSpan formatWithBoldPrefix({
    required String prefix,
    required String suffix,
    TextStyle? prefixStyle,
    TextStyle? suffixStyle,
  }) {
    return TextSpan(
      children: [
        TextSpan(
          text: prefix,
          style: prefixStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: suffix,
          style: suffixStyle,
        ),
      ],
    );
  }

  /// Creates a list of text spans from a list of strings.
  static List<TextSpan> textSpansFromStringList(
    List<String> strings, {
    TextStyle? style,
    String separator = ' ',
  }) {
    if (strings.isEmpty) return [];
    return strings.asMap().entries.map((entry) {
      return TextSpan(
        text: entry.value,
        style: style,
        children: entry.key < strings.length - 1
            ? [TextSpan(text: separator, style: style)]
            : null,
      );
    }).toList();
  }

  /// Highlights matching text within a string.
  static List<TextSpan> highlightMatches(
    String text,
    String query, {
    TextStyle? highlightStyle,
    TextStyle? normalStyle,
  }) {
    if (query.isEmpty) {
      return [TextSpan(text: text, style: normalStyle)];
    }

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;

    while (start < text.length) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: normalStyle,
        ));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: normalStyle,
        ));
      }

      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: highlightStyle,
      ));

      start = index + query.length;
    }

    return spans;
  }
}
