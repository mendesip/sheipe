import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheipe_app/shared/theme/app_colors.dart';
import 'package:sheipe_app/shared/theme/app_text_styles.dart';
import 'package:sheipe_app/shared/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('light theme is a ThemeData instance', () {
      expect(AppTheme.light, isA<ThemeData>());
    });

    test('light theme uses material3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
    });
  });

  group('AppColors', () {
    test('primary color is defined', () {
      expect(AppColors.primary, isA<Color>());
    });

    test('all colors are non-null', () {
      expect(AppColors.onPrimary, isA<Color>());
      expect(AppColors.background, isA<Color>());
      expect(AppColors.surface, isA<Color>());
      expect(AppColors.error, isA<Color>());
    });
  });

  group('AppTextStyles', () {
    test('headlineLarge is a TextStyle', () {
      expect(AppTextStyles.headlineLarge, isA<TextStyle>());
    });

    test('all styles are defined', () {
      expect(AppTextStyles.headlineMedium, isA<TextStyle>());
      expect(AppTextStyles.titleLarge, isA<TextStyle>());
      expect(AppTextStyles.bodyLarge, isA<TextStyle>());
      expect(AppTextStyles.bodyMedium, isA<TextStyle>());
      expect(AppTextStyles.labelMedium, isA<TextStyle>());
    });
  });
}
