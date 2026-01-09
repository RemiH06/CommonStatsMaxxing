import 'package:flutter/material.dart';
import 'Colors.dart';

class CsmTheme {
  // Tema claro
  static ThemeData GetLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: CsmColors.FONDO_CLARO,
      
      // Colores primarios
      primaryColor: CsmColors.MORADO_CONTORNOS,
      
      // Tema de texto
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: CsmColors.TEXTO_CLARO,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: CsmColors.TEXTO_CLARO,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: CsmColors.TEXTO_CLARO,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: CsmColors.TEXTO_CLARO,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Tema de cards (cajas con bordes redondeados)
      cardTheme: CardThemeData(
        color: CsmColors.FONDO_CLARO,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: CsmColors.MORADO_CONTORNOS,
            width: 2,
          ),
        ),
      ),
      
      // Tema de inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CsmColors.FONDO_CLARO,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CsmColors.MORADO_CONTORNOS,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CsmColors.MORADO_CONTORNOS,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CsmColors.AZUL_RUTINA,
            width: 2,
          ),
        ),
      ),
      
      // Tema de botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CsmColors.MORADO_CONTORNOS,
          foregroundColor: CsmColors.FONDO_CLARO,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Tema de app bar
      appBarTheme: const AppBarTheme(
        backgroundColor: CsmColors.FONDO_CLARO,
        foregroundColor: CsmColors.TEXTO_CLARO,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Tema de iconos
      iconTheme: const IconThemeData(
        color: CsmColors.TEXTO_CLARO,
      ),
    );
  }
  
  // Tema oscuro
  static ThemeData GetDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CsmColors.FONDO_OSCURO,
      
      // Colores primarios
      primaryColor: CsmColors.MORADO_CONTORNOS_DARK,
      
      // Tema de texto
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: CsmColors.TEXTO_OSCURO,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: CsmColors.TEXTO_OSCURO,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: CsmColors.TEXTO_OSCURO,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: CsmColors.TEXTO_OSCURO,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Tema de cards (cajas con bordes redondeados)
      cardTheme: CardThemeData(
        color: CsmColors.FONDO_OSCURO,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: CsmColors.MORADO_CONTORNOS_DARK,
            width: 2,
          ),
        ),
      ),
      
      // Tema de inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CsmColors.FONDO_OSCURO,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CsmColors.MORADO_CONTORNOS_DARK,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CsmColors.MORADO_CONTORNOS_DARK,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: CsmColors.AZUL_RUTINA_DARK,
            width: 2,
          ),
        ),
      ),
      
      // Tema de botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CsmColors.MORADO_CONTORNOS_DARK,
          foregroundColor: CsmColors.FONDO_OSCURO,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      // Tema de app bar
      appBarTheme: const AppBarTheme(
        backgroundColor: CsmColors.FONDO_OSCURO,
        foregroundColor: CsmColors.TEXTO_OSCURO,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Tema de iconos
      iconTheme: const IconThemeData(
        color: CsmColors.TEXTO_OSCURO,
      ),
    );
  }
}