import 'package:flutter/material.dart';

/// Customizable theme for the chat_flutter package.
/// Pass to [ChatModule.init] to override default colors and styles.
class ChatTheme {
  const ChatTheme({
    this.primaryColor = const Color(0xFF075E54),
    this.ownBubbleColor = const Color(0xFFDCF8C6),
    this.otherBubbleColor = const Color(0xFFFFFFFF),
    this.botBubbleColor = const Color(0xFFE3F2FD),
    this.scaffoldBackgroundColor = const Color(0xFFECE5DD),
    this.appBarColor = const Color(0xFF075E54),
    this.appBarTextColor = const Color(0xFFFFFFFF),
    this.primaryTextColor = const Color(0xFF000000),
    this.secondaryTextColor = const Color(0xFF667781),
    this.bubbleBorderRadius = 12.0,
    this.messageFontSize = 15.0,
    this.inputBarColor = const Color(0xFFFFFFFF),
    this.unreadBadgeColor = const Color(0xFF25D366),
    this.onlineIndicatorColor = const Color(0xFF25D366),
  });

  final Color primaryColor;
  final Color ownBubbleColor;
  final Color otherBubbleColor;
  final Color botBubbleColor;
  final Color scaffoldBackgroundColor;
  final Color appBarColor;
  final Color appBarTextColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final double bubbleBorderRadius;
  final double messageFontSize;
  final Color inputBarColor;
  final Color unreadBadgeColor;
  final Color onlineIndicatorColor;

  static const ChatTheme defaultTheme = ChatTheme();

  /// Creates a [ChatTheme] that adapts to the parent app's [ThemeData].
  ///
  /// Useful to integrate the chat package without manual color overrides:
  /// ```dart
  /// await ChatModule.init(
  ///   ...,
  ///   parentTheme: Theme.of(context),
  /// );
  /// ```
  factory ChatTheme.fromThemeData(ThemeData theme) {
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return ChatTheme(
      primaryColor: cs.primary,
      appBarColor: cs.primary,
      appBarTextColor: cs.onPrimary,
      ownBubbleColor: isDark
          ? cs.primaryContainer
          : cs.primaryContainer.withOpacity(0.6),
      otherBubbleColor: isDark ? cs.surfaceContainerHigh : cs.surface,
      botBubbleColor: isDark
          ? cs.secondaryContainer
          : cs.secondaryContainer.withOpacity(0.5),
      scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
      inputBarColor: cs.surface,
      primaryTextColor: cs.onSurface,
      secondaryTextColor: cs.onSurface.withOpacity(0.55),
      unreadBadgeColor: cs.primary,
      onlineIndicatorColor: cs.primary,
    );
  }

  ChatTheme copyWith({
    Color? primaryColor,
    Color? ownBubbleColor,
    Color? otherBubbleColor,
    Color? botBubbleColor,
    Color? scaffoldBackgroundColor,
    Color? appBarColor,
    Color? appBarTextColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    double? bubbleBorderRadius,
    double? messageFontSize,
    Color? inputBarColor,
    Color? unreadBadgeColor,
    Color? onlineIndicatorColor,
  }) {
    return ChatTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      ownBubbleColor: ownBubbleColor ?? this.ownBubbleColor,
      otherBubbleColor: otherBubbleColor ?? this.otherBubbleColor,
      botBubbleColor: botBubbleColor ?? this.botBubbleColor,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      appBarColor: appBarColor ?? this.appBarColor,
      appBarTextColor: appBarTextColor ?? this.appBarTextColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      bubbleBorderRadius: bubbleBorderRadius ?? this.bubbleBorderRadius,
      messageFontSize: messageFontSize ?? this.messageFontSize,
      inputBarColor: inputBarColor ?? this.inputBarColor,
      unreadBadgeColor: unreadBadgeColor ?? this.unreadBadgeColor,
      onlineIndicatorColor: onlineIndicatorColor ?? this.onlineIndicatorColor,
    );
  }
}
