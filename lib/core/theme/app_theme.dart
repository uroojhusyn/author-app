import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'app_text_styles.dart';

/// Complete Material 3 ThemeData for the BlogHub Authors app.
/// Built directly according to the BlogHub THEME.md design system.
/// Both [lightTheme] and [darkTheme] are generated from shared helpers so
/// they stay in sync - only surfaces and foregrounds differ.
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // Public accessors
  // ---------------------------------------------------------------------------
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  // ---------------------------------------------------------------------------
  // Builder
  // ---------------------------------------------------------------------------
  static ThemeData _buildTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    final ColorScheme colorScheme = isLight
        ? const ColorScheme.light(
            primary: AppColors.authorPrimary,
            onPrimary: AppColors.onPrimary,
            primaryContainer: AppColors.authorNavActiveBg,
            onPrimaryContainer: AppColors.authorPrimaryHover,
            secondary: AppColors.brandPurple,
            onSecondary: Colors.white,
            secondaryContainer: AppColors.brandPurpleSoft,
            onSecondaryContainer: AppColors.brandPurpleHover,
            tertiary: AppColors.brandNavy,
            error: AppColors.statusDanger,
            errorContainer: AppColors.statusDangerBg,
            surface: AppColors.surfaceLight,
            onSurface: AppColors.textPrimaryLight,
            surfaceContainerHighest: AppColors.surfaceVariantLight,
            onSurfaceVariant: AppColors.textSecondaryLight,
            outline: AppColors.borderLight,
            outlineVariant: AppColors.dividerLight,
            shadow: AppColors.shadowMedium,
            scrim: AppColors.scrim,
          )
        : const ColorScheme.dark(
            primary: AppColors.authorPrimaryDark,
            onPrimary: AppColors.backgroundDark,
            primaryContainer: Color(0x266366F1),
            onPrimaryContainer: Color(0xFFA5B4FC),
            secondary: Color(0xFF7568F6),
            onSecondary: AppColors.backgroundDark,
            secondaryContainer: Color(0x267568F6),
            onSecondaryContainer: Color(0xFFC7D2FE),
            tertiary: Color(0xFF818CF8),
            error: AppColors.statusDanger,
            errorContainer: Color(0x33EF4444),
            surface: AppColors.cardDark,
            onSurface: AppColors.textPrimaryDark,
            surfaceContainerHighest: AppColors.surfaceDark,
            onSurfaceVariant: AppColors.textSecondaryDark,
            outline: AppColors.borderDark,
            outlineVariant: AppColors.dividerDark,
            shadow: AppColors.shadowMedium,
            scrim: AppColors.scrim,
          );

    // Use DM Sans as the global text theme base (BlogHub THEME.md Section 2)
    final TextTheme baseTextTheme = GoogleFonts.dmSansTextTheme(
      isLight ? ThemeData.light().textTheme : ThemeData.dark().textTheme,
    ).copyWith(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isLight ? AppColors.backgroundLight : AppColors.backgroundDark,
      textTheme: baseTextTheme,
      primaryTextTheme: baseTextTheme,

      // -----------------------------------------------------------------------
      // AppBar (White / Dark, subtle border, no heavy elevation)
      // -----------------------------------------------------------------------
      appBarTheme: AppBarTheme(
        backgroundColor:
            isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        foregroundColor:
            isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          color: isLight
              ? AppColors.textPrimaryLight
              : AppColors.textPrimaryDark,
        ),
        iconTheme: IconThemeData(
          color: isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
          size: AppSpacing.iconLg,
        ),
        shape: Border(
          bottom: BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
            width: 1,
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // Card (THEME.md: 14px radius, 1px border #E8E9EF, elevation 0)
      // -----------------------------------------------------------------------
      cardTheme: CardThemeData(
        color: isLight ? AppColors.cardLight : AppColors.cardDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
            width: 1,
          ),
        ),
        shadowColor: AppColors.shadowLight,
      ),

      // -----------------------------------------------------------------------
      // Elevated button (THEME.md: 8px radius, AuthorPrimary #4F46E5)
      // -----------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.authorPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),

      // -----------------------------------------------------------------------
      // Outlined button (THEME.md: 8px radius, border #E8E9EF)
      // -----------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
          backgroundColor: isLight ? Colors.white : AppColors.cardDark,
          side: BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),

      // -----------------------------------------------------------------------
      // Text button
      // -----------------------------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.authorPrimary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // -----------------------------------------------------------------------
      // FilledButton (THEME.md: 8px radius)
      // -----------------------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.authorPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),

      // -----------------------------------------------------------------------
      // Input decoration (THEME.md: 8px radius, clean 1px border)
      // -----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: isLight ? AppColors.textHintLight : AppColors.textHintDark,
        ),
        labelStyle: AppTextStyles.fieldLabel.copyWith(
          color: isLight
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
        ),
        floatingLabelStyle: AppTextStyles.fieldLabel.copyWith(
          color: AppColors.authorPrimary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: isLight ? AppColors.borderLight : AppColors.borderDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide:
              const BorderSide(color: AppColors.authorPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.statusDanger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide:
              const BorderSide(color: AppColors.statusDanger, width: 1.5),
        ),
        errorStyle:
            AppTextStyles.bodySmall.copyWith(color: AppColors.statusDanger),
        prefixIconColor: isLight ? AppColors.iconLight : AppColors.iconDark,
        suffixIconColor: isLight ? AppColors.iconLight : AppColors.iconDark,
      ),

      // -----------------------------------------------------------------------
      // Chip (THEME.md: pills 9999px radius)
      // -----------------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: isLight
            ? AppColors.surfaceVariantLight
            : AppColors.surfaceVariantDark,
        labelStyle: AppTextStyles.chip.copyWith(
          color: isLight
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          side: BorderSide.none,
        ),
        elevation: 0,
        side: BorderSide.none,
      ),

      // -----------------------------------------------------------------------
      // Divider
      // -----------------------------------------------------------------------
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.dividerLight : AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),

      // -----------------------------------------------------------------------
      // List tile
      // -----------------------------------------------------------------------
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        titleTextStyle: AppTextStyles.titleSmall.copyWith(
          color: isLight
              ? AppColors.textPrimaryLight
              : AppColors.textPrimaryDark,
        ),
        subtitleTextStyle: AppTextStyles.bodySmall.copyWith(
          color: isLight
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
        ),
        iconColor: isLight ? AppColors.iconLight : AppColors.iconDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),

      // -----------------------------------------------------------------------
      // Bottom navigation bar
      // -----------------------------------------------------------------------
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        selectedItemColor: AppColors.authorPrimary,
        unselectedItemColor:
            isLight ? AppColors.iconLight : AppColors.iconDark,
        selectedLabelStyle:
            AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.labelSmall,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // -----------------------------------------------------------------------
      // Navigation bar (Material 3)
      // -----------------------------------------------------------------------
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
        indicatorColor: isLight
            ? AppColors.authorNavActiveBg
            : const Color(0x266366F1),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: isLight
                  ? AppColors.authorPrimary
                  : AppColors.authorPrimaryDark,
            );
          }
          return IconThemeData(
            color: isLight ? AppColors.iconLight : AppColors.iconDark,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSmall.copyWith(
              color: isLight
                  ? AppColors.authorPrimary
                  : AppColors.authorPrimaryDark,
              fontWeight: FontWeight.w700,
            );
          }
          return AppTextStyles.labelSmall.copyWith(
            color: isLight ? AppColors.iconLight : AppColors.iconDark,
          );
        }),
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      // -----------------------------------------------------------------------
      // Dialog
      // -----------------------------------------------------------------------
      dialogTheme: DialogThemeData(
        backgroundColor:
            isLight ? AppColors.surfaceLight : AppColors.cardDark,
        elevation: AppSpacing.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: isLight
              ? AppColors.textPrimaryLight
              : AppColors.textPrimaryDark,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: isLight
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
        ),
      ),

      // -----------------------------------------------------------------------
      // SnackBar
      // -----------------------------------------------------------------------
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isLight ? AppColors.brandNavy : AppColors.surfaceVariantDark,
        contentTextStyle:
            AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppSpacing.elevationMd,
      ),

      // -----------------------------------------------------------------------
      // Progress indicator
      // -----------------------------------------------------------------------
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.authorPrimary,
        linearTrackColor: AppColors.authorNavActiveBg,
        circularTrackColor: AppColors.authorNavActiveBg,
      ),

      // -----------------------------------------------------------------------
      // Switch / Checkbox / Radio
      // -----------------------------------------------------------------------
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.authorPrimary
                : (isLight ? AppColors.borderLight : AppColors.borderDark)),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? AppColors.authorNavActiveBg
                : (isLight
                    ? AppColors.surfaceVariantLight
                    : AppColors.surfaceVariantDark)),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.authorPrimary
              : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        ),
        side: BorderSide(
          color: isLight ? AppColors.borderLight : AppColors.borderDark,
          width: 1.5,
        ),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.authorPrimary
              : (isLight ? AppColors.iconLight : AppColors.iconDark),
        ),
      ),

      // -----------------------------------------------------------------------
      // Tab bar
      // -----------------------------------------------------------------------
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.authorPrimary,
        unselectedLabelColor: isLight
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
        labelStyle: AppTextStyles.titleSmall,
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        indicatorColor: AppColors.authorPrimary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
      ),

      // -----------------------------------------------------------------------
      // Floating action button
      // -----------------------------------------------------------------------
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.authorPrimary,
        foregroundColor: Colors.white,
        elevation: AppSpacing.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // -----------------------------------------------------------------------
      // Page transitions
      // -----------------------------------------------------------------------
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
