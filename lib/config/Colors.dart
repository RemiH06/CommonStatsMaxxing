import 'package:flutter/material.dart';

class CsmColors {
  // Modo claro - colores vibrantes tendiendo a pastel
  static const Color ROSA_RECETAS = Color(0xFFFF6B9D);
  static const Color MORADO_CONTORNOS = Color(0xFFB967FF);
  static const Color AZUL_RUTINA = Color(0xFF5AB9EA);
  static const Color VERDE_DIETA = Color(0xFF4ECDC4);
  static const Color AMARILLO_COMPRAS = Color(0xFFFFC75F);
  static const Color NARANJA_INGREDIENTES = Color(0xFFFF8C42);
  static const Color ROJO_IMPORTANTE = Color(0xFFFF5757);
  
  static const Color FONDO_CLARO = Color(0xFFFFFFFF);
  static const Color TEXTO_CLARO = Color(0xFF000000);
  
  // Modo oscuro - colores más pastel
  static const Color ROSA_RECETAS_DARK = Color(0xFFFFB3D9);
  static const Color MORADO_CONTORNOS_DARK = Color(0xFFD4A5FF);
  static const Color AZUL_RUTINA_DARK = Color(0xFF87CEEB);
  static const Color VERDE_DIETA_DARK = Color(0xFF7FFFD4);
  static const Color AMARILLO_COMPRAS_DARK = Color(0xFFFFE4A0);
  static const Color NARANJA_INGREDIENTES_DARK = Color(0xFFFFB380);
  static const Color ROJO_IMPORTANTE_DARK = Color(0xFFFF9999);
  
  static const Color FONDO_OSCURO = Color(0xFF000000);
  static const Color TEXTO_OSCURO = Color(0xFFFFFFFF);
  
  // Metodo para obtener colores según tema
  static Color GetRosaRecetas(bool isDark) => 
    isDark ? ROSA_RECETAS_DARK : ROSA_RECETAS;
  
  static Color GetMoradoContornos(bool isDark) => 
    isDark ? MORADO_CONTORNOS_DARK : MORADO_CONTORNOS;
  
  static Color GetAzulRutina(bool isDark) => 
    isDark ? AZUL_RUTINA_DARK : AZUL_RUTINA;
  
  static Color GetVerdeDieta(bool isDark) => 
    isDark ? VERDE_DIETA_DARK : VERDE_DIETA;
  
  static Color GetAmarilloCompras(bool isDark) => 
    isDark ? AMARILLO_COMPRAS_DARK : AMARILLO_COMPRAS;
  
  static Color GetNaranjaIngredientes(bool isDark) => 
    isDark ? NARANJA_INGREDIENTES_DARK : NARANJA_INGREDIENTES;
  
  static Color GetRojoImportante(bool isDark) => 
    isDark ? ROJO_IMPORTANTE_DARK : ROJO_IMPORTANTE;
  
  static Color GetFondo(bool isDark) => 
    isDark ? FONDO_OSCURO : FONDO_CLARO;
  
  static Color GetTexto(bool isDark) => 
    isDark ? TEXTO_OSCURO : TEXTO_CLARO;
}