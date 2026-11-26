import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typographic scale for the BlogHub Authors design system.
/// Direct implementation of BlogHub THEME.md Section 2:
/// - DM Sans (Primary Sans): Body, navigation, buttons, labels, inputs
/// - Playfair Display (Editorial Serif): Post titles, banner greetings, section headers, card titles
/// - IBM Plex Mono (Monospace): Stats, counters, dates, post IDs, code
class AppTextStyles {
  AppTextStyles._();

  // ── Font family helpers ────────────────────────────────────────────────────
  static TextStyle _dmSans({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) =>
      GoogleFonts.dmSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );

  static TextStyle _playfair({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) =>
      GoogleFonts.playfairDisplay(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );

  static TextStyle _ibmPlexMono({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) =>
      GoogleFonts.ibmPlexMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      );

  // ── Display (Editorial Serif - Playfair Display) ──────────────────────────
  static TextStyle get displayLarge => _playfair(fontSize: 34, fontWeight: FontWeight.w700, height: 1.15);
  static TextStyle get displayMedium => _playfair(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle get displaySmall => _playfair(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25);

  // ── Headline (Editorial Serif / Dignified Headers) ─────────────────────────
  static TextStyle get headlineLarge => _playfair(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25);
  static TextStyle get headlineMedium => _playfair(fontSize: 20, fontWeight: FontWeight.w700, height: 1.3);
  static TextStyle get headlineSmall => _playfair(fontSize: 18, fontWeight: FontWeight.w600, height: 1.35);

  // ── Title (DM Sans / SemiBold UI) ─────────────────────────────────────────
  static TextStyle get titleLarge => _dmSans(fontSize: 17, fontWeight: FontWeight.w600, height: 1.4);
  static TextStyle get titleMedium => _dmSans(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: 0.1);
  static TextStyle get titleSmall => _dmSans(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: 0.1);

  // ── Body (DM Sans) ────────────────────────────────────────────────────────
  static TextStyle get bodyLarge => _dmSans(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle get bodyMedium => _dmSans(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle get bodySmall => _dmSans(fontSize: 13, fontWeight: FontWeight.w400, height: 1.5);

  // ── Label (DM Sans) ───────────────────────────────────────────────────────
  static TextStyle get labelLarge => _dmSans(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1);
  static TextStyle get labelMedium => _dmSans(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.3);
  static TextStyle get labelSmall => _dmSans(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4);

  // ── Semantic helpers ───────────────────────────────────────────────────────
  /// App-bar title
  static TextStyle get appBarTitle => _dmSans(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.2);

  /// Editorial banner heading
  static TextStyle get bannerHeading => _playfair(fontSize: 22, fontWeight: FontWeight.w700, height: 1.25);

  /// Post editor headline input
  static TextStyle get editorHeadline => _playfair(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3);

  /// Input field label (above the field)
  static TextStyle get fieldLabel => _dmSans(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.2);

  /// Chip / badge text (status, category)
  static TextStyle get chip => _dmSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.4);

  /// Post card title in list / grid (Playfair Display per THEME.md H3 Card Title)
  static TextStyle get postCardTitle => _playfair(fontSize: 17, fontWeight: FontWeight.w700, height: 1.35);

  /// Post card excerpt / secondary copy (DM Sans)
  static TextStyle get postCardExcerpt => _dmSans(fontSize: 14, fontWeight: FontWeight.w400, height: 1.55);

  /// Section header (Playfair Display)
  static TextStyle get sectionHeader => _playfair(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.2);

  /// Button label (DM Sans, 14px, weight 600 per THEME.md Flutter snippet)
  static TextStyle get button => _dmSans(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2);

  /// Stat / metric number (dashboard: 28px bold per THEME.md Component Blueprint)
  static TextStyle get statNumber => _dmSans(fontSize: 28, fontWeight: FontWeight.w700, height: 1.15, letterSpacing: -0.5);

  /// Stat label (uppercase, letter-spacing: 0.5px per THEME.md)
  static TextStyle get statLabel => _dmSans(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  /// Monospace for reading stats, post IDs, counters, code
  static TextStyle get monoStats => _ibmPlexMono(fontSize: 12, fontWeight: FontWeight.w500);
}
