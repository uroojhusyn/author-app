import 'package:flutter/material.dart';

/// Central color palette for the BlogHub Authors design system.
/// Direct specification from BlogHub THEME.md.
/// Never use raw Color literals in widgets — always reference this class.
class AppColors {
  AppColors._();

  // ── Author Studio Colors (Core Action Palette) ───────────────────────────
  /// Indigo 600 — Primary action button, active tab, key actions
  static const Color authorPrimary = Color(0xFF4F46E5);
  /// Indigo 700 — Hover / active pressed state
  static const Color authorPrimaryHover = Color(0xFF4338CA);
  /// Indigo gradient start
  static const Color authorGradientStart = Color(0xFF4F46E5);
  /// Indigo gradient end
  static const Color authorGradientEnd = Color(0xFF3730A3);
  /// Author Studio pill badge background
  static const Color authorBadgeBg = Color(0xFFE0E7FF);
  /// Author Studio pill badge text
  static const Color authorBadgeText = Color(0xFF4338CA);
  /// Author navigation active background
  static const Color authorNavActiveBg = Color(0xFFEEF2FF);
  /// Dark mode author primary
  static const Color authorPrimaryDark = Color(0xFF6366F1);

  // ── Brand Colors ─────────────────────────────────────────────────────────
  /// Slate Navy — Brand dark color; header bars, newsletter boxes, dark accents
  static const Color brandNavy = Color(0xFF26345A);
  /// Electric Violet — Primary brand accent for website buttons & icons
  static const Color brandPurple = Color(0xFF6254E8);
  /// Deep Violet — Hover state for website buttons
  static const Color brandPurpleHover = Color(0xFF5041D1);
  /// Soft Violet — Light background tint for active items & tech badges
  static const Color brandPurpleSoft = Color(0xFFEEEAFF);

  // ── Backward-Compatible Primary Aliases ──────────────────────────────────
  static const Color primary = authorPrimary;
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = authorPrimaryHover;
  static const Color primaryContainer = authorNavActiveBg;
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Amber accent — highlights, badges
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFCD34D);
  static const Color accentDark = Color(0xFFD97706);
  static const Color accentContainer = Color(0xFFFFFBEB);
  static const Color onAccent = Color(0xFF1C1917);

  // ── Status & State Colors (THEME.md Specification) ───────────────────────
  /// Approved / Published (Emerald)
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusSuccessBg = Color(0xFFE6F9F0);
  static const Color statusSuccessText = Color(0xFF065F46);

  /// Pending / In Review (Amber)
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusWarningBg = Color(0xFFFFFBEB);
  static const Color statusWarningText = Color(0xFFB45309);

  /// Rejected / Revisions (Rose / Danger)
  static const Color statusDanger = Color(0xFFEF4444);
  static const Color statusDangerBg = Color(0xFFFEF2F2);
  static const Color statusDangerText = Color(0xFFB91C1C);

  /// Draft (Slate)
  static const Color statusDraft = Color(0xFF64748B);
  static const Color statusDraftBg = Color(0xFFF1F5F9);
  static const Color statusDraftText = Color(0xFF475569);
  static const Color statusDraftBorder = Color(0xFF94A3B8);

  // Semantic aliases for existing code
  static const Color success = statusSuccess;
  static const Color successContainer = statusSuccessBg;
  static const Color warning = statusWarning;
  static const Color warningContainer = statusWarningBg;
  static const Color error = statusDanger;
  static const Color errorContainer = statusDangerBg;
  static const Color info = Color(0xFF248ED4);
  static const Color infoContainer = Color(0xFFEAF5FF);

  static const Color published = statusSuccess;
  static const Color secondary = brandPurple;
  static const Color secondaryLight = Color(0xFF7568F6);
  static const Color secondaryContainer = brandPurpleSoft;
  static const Color draft = statusWarning;
  static const Color archived = Color(0xFF64748B);

  // ── Category Color Palette (THEME.md Specification) ──────────────────────
  static const Color catTechBg = Color(0xFFEEEAFF);
  static const Color catTechText = Color(0xFF6553E8);

  static const Color catEducationBg = Color(0xFFFFF0E7);
  static const Color catEducationText = Color(0xFFEE7537);

  static const Color catTravelBg = Color(0xFFEAF5FF);
  static const Color catTravelText = Color(0xFF248ED4);

  static const Color catFoodBg = Color(0xFFFFF1EB);
  static const Color catFoodText = Color(0xFFE46B32);

  static const Color catBusinessBg = Color(0xFFE9F5FF);
  static const Color catBusinessText = Color(0xFF238BC9);

  static const Color catSportsBg = Color(0xFFFFECEC);
  static const Color catSportsText = Color(0xFFE15353);

  static const Color catLifestyleBg = Color(0xFFE6F9F0);
  static const Color catLifestyleText = Color(0xFF10B981);

  static const Color catHealthBg = Color(0xFFFDF2F8);
  static const Color catHealthText = Color(0xFFEC4899);

  static const Color catGeneralBg = Color(0xFFF1F5F9);
  static const Color catGeneralText = Color(0xFF64748B);

  /// Helper to get category background and text colors based on name
  static ({Color bg, Color text}) getCategoryColors(String category) {
    final lower = category.toLowerCase().trim();
    if (lower.contains('tech') || lower.contains('backend') || lower.contains('database') || lower.contains('devops')) {
      return (bg: catTechBg, text: catTechText);
    } else if (lower.contains('educat') || lower.contains('tutorial') || lower.contains('learn')) {
      return (bg: catEducationBg, text: catEducationText);
    } else if (lower.contains('travel') || lower.contains('place') || lower.contains('tour')) {
      return (bg: catTravelBg, text: catTravelText);
    } else if (lower.contains('food') || lower.contains('cook') || lower.contains('recipe')) {
      return (bg: catFoodBg, text: catFoodText);
    } else if (lower.contains('business') || lower.contains('finance') || lower.contains('money')) {
      return (bg: catBusinessBg, text: catBusinessText);
    } else if (lower.contains('sport') || lower.contains('fitness') || lower.contains('workout')) {
      return (bg: catSportsBg, text: catSportsText);
    } else if (lower.contains('life') || lower.contains('art') || lower.contains('design') || lower.contains('ui')) {
      return (bg: catLifestyleBg, text: catLifestyleText);
    } else if (lower.contains('health') || lower.contains('well') || lower.contains('care')) {
      return (bg: catHealthBg, text: catHealthText);
    }
    return (bg: catGeneralBg, text: catGeneralText);
  }

  // ── Light Theme Surfaces (THEME.md Specification) ────────────────────────
  /// Main page canvas (soft-bg: #F8F9FC)
  static const Color backgroundLight = Color(0xFFF8F9FC);
  /// Cards, sheets, surface: #FFFFFF
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  /// Primary text: #171A24
  static const Color textPrimaryLight = Color(0xFF171A24);
  /// Muted secondary text: #737783
  static const Color textSecondaryLight = Color(0xFF737783);
  /// Subtle / counters / timestamps: #888B94
  static const Color textHintLight = Color(0xFF888B94);
  /// Card and input borders: #E8E9EF
  static const Color borderLight = Color(0xFFE8E9EF);
  static const Color dividerLight = Color(0xFFE8E9EF);
  static const Color iconLight = Color(0xFF737783);

  // ── Dark Theme Surfaces (THEME.md Specification) ─────────────────────────
  /// Main dark canvas: #111422
  static const Color backgroundDark = Color(0xFF111422);
  /// Dark soft-bg: #181D31
  static const Color surfaceDark = Color(0xFF181D31);
  /// Elevated card surface: #1E243D
  static const Color cardDark = Color(0xFF1E243D);
  static const Color surfaceVariantDark = Color(0xFF1E243D);
  /// Dark text: #F3F4F6
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  /// Dark muted: #9AA1B5
  static const Color textSecondaryDark = Color(0xFF9AA1B5);
  /// Dark subtle: #767D94
  static const Color textHintDark = Color(0xFF767D94);
  /// Dark border: #29304F
  static const Color borderDark = Color(0xFF29304F);
  static const Color dividerDark = Color(0xFF29304F);
  static const Color iconDark = Color(0xFF9AA1B5);

  // ── Shadows (THEME.md: 0 10px 30px rgba(34, 39, 70, 0.08)) ──────────────
  static const Color shadowLight = Color(0x14222746);
  static const Color shadowMedium = Color(0x1F222746);

  // ── Overlay / Scrim ──────────────────────────────────────────────────────
  static const Color scrim = Color(0x52000000);
}
