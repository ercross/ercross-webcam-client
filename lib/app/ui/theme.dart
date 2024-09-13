import 'package:flutter/material.dart';

import 'colors.dart';

abstract class AppTheme {
  static const String font = "Satoshi";

  static const _lightModeInputDecorationTheme = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: EdgeInsets.fromLTRB(18, 12, 18, 12),
    isDense: true,
    fillColor: Colors.white,
    filled: true,
    focusColor: AppColor.primary,
    suffixIconColor: AppColor.iconBlack,
    constraints:
        BoxConstraints(maxHeight: 67, minHeight: 47, maxWidth: double.infinity),
    hintStyle: TextStyle(
      color: AppColor.gray400,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: TextStyle(
        fontFamily: font,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.red),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.red,
        )),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColor.primary,
        )),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColor.outline,
        )),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColor.primary,
          width: 2,
        )),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColor.outline,
        )),
  );

  static ThemeData lightMode = ThemeData(
      datePickerTheme: const DatePickerThemeData(
        dayStyle: TextStyle(
          fontFamily: font,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF0F172A),
        ),
        weekdayStyle: TextStyle(
          fontFamily: font,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColor.primary,
        ),
        headerHeadlineStyle: TextStyle(
          fontFamily: font,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F172A),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateTextStyle.resolveWith((_) =>
              const TextStyle(
                  fontSize: 12,
                  fontFamily: font,
                  color: AppColor.gray600,
                  fontWeight: FontWeight.w400))),
      iconTheme: const IconThemeData(size: 24, color: AppColor.iconBlack),
      fontFamily: font,
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleSize: Size(120, 2),
          backgroundColor: Colors.white,
          elevation: 12,
          showDragHandle: true,
          dragHandleColor: AppColor.gray400,
          clipBehavior: Clip.none,
          modalBarrierColor: Colors.black12,
          modalBackgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)))),
      dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: const TextStyle(
            fontFamily: font,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.gray800,
          ),
          menuStyle: MenuStyle(
            shape: WidgetStateProperty.resolveWith((_) =>
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)))),
            elevation: WidgetStateProperty.resolveWith((_) => 12),
            backgroundColor: WidgetStateColor.resolveWith((_) => Colors.white),
            padding: WidgetStateProperty.resolveWith(
                (_) => const EdgeInsets.fromLTRB(12, 16, 16, 16)),
          ),
          inputDecorationTheme: _lightModeInputDecorationTheme),
      colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
          onSurface: AppColor.gray800,
          outline: AppColor.outline,
          brightness: Brightness.light,
          surface: AppColor.backgroundWhite),
      scaffoldBackgroundColor: AppColor.backgroundWhite,
      indicatorColor: AppColor.gray600,
      inputDecorationTheme: _lightModeInputDecorationTheme,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              padding: WidgetStateProperty.resolveWith(
                  (states) => const EdgeInsets.all(10)),
              minimumSize: WidgetStateProperty.resolveWith<Size>(
                  (_) => const Size(double.infinity, 47)),
              textStyle:
                  WidgetStateProperty.resolveWith<TextStyle>((_) => TextStyle(
                        fontSize: 14,
                        foreground: Paint()..color = const Color(0xFF437CE3),
                        fontFamily: font,
                        fontWeight: FontWeight.w500,
                      )))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.resolveWith<Size>(
              (_) => const Size(double.infinity, 46)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor:
              WidgetStateProperty.resolveWith<Color>((_) => AppColor.primary),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          textStyle:
              WidgetStateProperty.resolveWith<TextStyle>((_) => TextStyle(
                    fontSize: 16,
                    foreground: Paint()..color = Colors.white,
                    fontFamily: font,
                    fontWeight: FontWeight.w700,
                  )),
        ),
      ),
      textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: font,
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontFamily: font,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColor.iconBlack,
          ),
          headlineSmall: TextStyle(
            fontFamily: font,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: font,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColor.gray800,
          ),
          bodyMedium: TextStyle(
            fontFamily: font,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.gray800,
          ),
          bodySmall: TextStyle(
              fontFamily: font,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.gray400),
          labelLarge: TextStyle(
            fontFamily: font,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.gray600,
          )));
}
