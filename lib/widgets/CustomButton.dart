import 'package:flutter/material.dart';
import '../config/Colors.dart';
import '../config/Constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;
  
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // obtiene el tema actual
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // determina colores
    final bgColor = backgroundColor ?? CsmColors.GetMoradoContornos(isDark);
    final fgColor = textColor ?? CsmColors.GetFondo(isDark);
    
    if (isOutlined) {
      // boton con borde
      return SizedBox(
        width: width,
        height: height ?? 48,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: bgColor,
              width: CsmConstants.BORDER_WIDTH,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_MEDIUM),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: CsmConstants.PADDING_MEDIUM,
              vertical: CsmConstants.PADDING_SMALL,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(bgColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: bgColor,
                        size: CsmConstants.ICON_SIZE_MEDIUM,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: bgColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }
    
    // boton solido
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_MEDIUM),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: CsmConstants.PADDING_MEDIUM,
            vertical: CsmConstants.PADDING_SMALL,
          ),
          elevation: 2,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: fgColor,
                      size: CsmConstants.ICON_SIZE_MEDIUM,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// variantes especializadas del boton para diferentes acciones

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: CsmColors.GetMoradoContornos(isDark),
    );
  }
}

class DietButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const DietButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: CsmColors.GetVerdeDieta(isDark),
    );
  }
}

class RoutineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const RoutineButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: CsmColors.GetAzulRutina(isDark),
    );
  }
}

class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  
  const DangerButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: CsmColors.GetRojoImportante(isDark),
    );
  }
}