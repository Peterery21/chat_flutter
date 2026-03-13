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
    this.errorColor = const Color(0xFFD32F2F),
    this.warningColor = const Color(0xFFF57C00),
    this.botIndicatorColor = const Color(0xFF00897B),
    this.avatarColors = _defaultAvatarColors,
    this.surfaceColor = const Color(0xFFFFFFFF),
    this.dividerColor = const Color(0xFFE0E0E0),
    this.hintColor = const Color(0xFF9E9E9E),
    this.inputFillColor = const Color(0xFFF5F5F5),
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

  /// Color used for destructive/error actions (delete, error messages).
  final Color errorColor;

  /// Color used for warning actions (leave group, etc.).
  final Color warningColor;

  /// Accent color for bot badges, bot avatars and bot indicators.
  final Color botIndicatorColor;

  /// Color palette used to generate user avatar backgrounds.
  final List<Color> avatarColors;

  /// Surface/card color for containers, overlays and cards.
  final Color surfaceColor;

  /// Color for dividers and subtle borders.
  final Color dividerColor;

  /// Color for hints, placeholders and empty-state icons/text.
  final Color hintColor;

  /// Fill color for text input fields.
  final Color inputFillColor;

  static const ChatTheme defaultTheme = ChatTheme();

  static const List<Color> _defaultAvatarColors = [
    Color(0xFF1976D2),
    Color(0xFF388E3C),
    Color(0xFF7B1FA2),
    Color(0xFFE64A19),
    Color(0xFF0288D1),
    Color(0xFF00796B),
    Color(0xFFC2185B),
    Color(0xFF5D4037),
  ];

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
    // Inherit AppBar colors from parent AppBarTheme so chat screens
    // match the parent app's navigation style exactly.
    final appBarBg =
        theme.appBarTheme.backgroundColor ?? cs.surface;
    final appBarFg =
        theme.appBarTheme.foregroundColor ?? cs.onSurface;
    return ChatTheme(
      primaryColor: cs.primary,
      appBarColor: appBarBg,
      appBarTextColor: appBarFg,
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
      errorColor: cs.error,
      warningColor: const Color(0xFFF57C00),
      botIndicatorColor: cs.secondary,
      avatarColors: _defaultAvatarColors,
      surfaceColor: theme.cardColor ?? cs.surface,
      dividerColor: theme.dividerColor,
      hintColor: theme.hintColor,
      inputFillColor: theme.inputDecorationTheme.fillColor ??
          (isDark
              ? cs.surfaceContainerHighest
              : cs.surfaceContainerHighest.withOpacity(0.6)),
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
    Color? errorColor,
    Color? warningColor,
    Color? botIndicatorColor,
    List<Color>? avatarColors,
    Color? surfaceColor,
    Color? dividerColor,
    Color? hintColor,
    Color? inputFillColor,
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
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      botIndicatorColor: botIndicatorColor ?? this.botIndicatorColor,
      avatarColors: avatarColors ?? this.avatarColors,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      dividerColor: dividerColor ?? this.dividerColor,
      hintColor: hintColor ?? this.hintColor,
      inputFillColor: inputFillColor ?? this.inputFillColor,
    );
  }
}
