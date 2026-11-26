/// Spacing and radius constants for the BlogHub Authors design system.
/// Use these tokens everywhere — never hard-code a pixel value in a widget.
class AppSpacing {
  AppSpacing._();

  // ── Base spacing scale (4-pt grid) ────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // ── Named semantic aliases ─────────────────────────────────────────────────
  static const double screenPadding = lg;          // outer page margins
  static const double cardPadding = lg;            // internal card padding
  static const double sectionGap = xxl;            // gap between page sections
  static const double itemGap = md;                // gap between list items
  static const double inlineGap = sm;              // gap between inline elements
  static const double iconTextGap = xs + sm;       // 12 — icon-beside-label

  // ── Border radius (THEME.md Specification) ───────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;     // buttons, small inputs, category tags
  static const double radiusMd = 14.0;    // standard cards, modals, sheets
  static const double radiusLg = 16.0;    // banners, hero containers
  static const double radiusCard = 14.0;  // explicit alias from THEME.md
  static const double radiusBanner = 16.0;// explicit alias from THEME.md
  static const double radiusXl = 20.0;
  static const double radiusFull = 999.0; // pills, chips, status badges

  // ── Icon sizes ─────────────────────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // ── Avatar sizes ───────────────────────────────────────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 44.0;
  static const double avatarLg = 64.0;

  // ── Elevation / shadow spread ─────────────────────────────────────────────
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;

  // ── Animation durations (ms) ───────────────────────────────────────────────
  static const int durationFast = 150;
  static const int durationNormal = 250;
  static const int durationSlow = 400;
}
