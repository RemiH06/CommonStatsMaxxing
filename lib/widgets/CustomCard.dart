import 'package:flutter/material.dart';
import '../config/Colors.dart';
import '../config/Constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? borderRadius;
  final double? borderWidth;
  
  const CustomCard({
    Key? key,
    required this.child,
    this.borderColor,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.borderWidth,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final effectiveBorderColor = borderColor ?? CsmColors.GetMoradoContornos(isDark);
    final effectiveBackgroundColor = backgroundColor ?? CsmColors.GetFondo(isDark);
    final effectiveBorderRadius = borderRadius ?? CsmConstants.BORDER_RADIUS_LARGE;
    final effectiveBorderWidth = borderWidth ?? CsmConstants.BORDER_WIDTH;
    
    final cardWidget = Container(
      padding: padding ?? const EdgeInsets.all(CsmConstants.PADDING_MEDIUM),
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border.all(
          color: effectiveBorderColor,
          width: effectiveBorderWidth,
        ),
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: child,
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        child: cardWidget,
      );
    }
    
    return cardWidget;
  }
}

// variantes especializadas de cards para diferentes secciones

class DietCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  
  const DietCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomCard(
      borderColor: CsmColors.GetVerdeDieta(isDark),
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

class RoutineCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  
  const RoutineCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomCard(
      borderColor: CsmColors.GetAzulRutina(isDark),
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  
  const RecipeCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomCard(
      borderColor: CsmColors.GetRosaRecetas(isDark),
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

class ShoppingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  
  const ShoppingCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomCard(
      borderColor: CsmColors.GetAmarilloCompras(isDark),
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

class IngredientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  
  const IngredientCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomCard(
      borderColor: CsmColors.GetNaranjaIngredientes(isDark),
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

class WarningCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  
  const WarningCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomCard(
      borderColor: CsmColors.GetRojoImportante(isDark),
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

// card expandible personalizado
class ExpandableCard extends StatefulWidget {
  final Widget title;
  final Widget child;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;
  final bool initiallyExpanded;
  
  const ExpandableCard({
    Key? key,
    required this.title,
    required this.child,
    this.borderColor,
    this.margin,
    this.initiallyExpanded = false,
  }) : super(key: key);
  
  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _isExpanded;
  
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderColor = widget.borderColor ?? CsmColors.GetMoradoContornos(isDark);
    
    return Container(
      margin: widget.margin ?? const EdgeInsets.only(bottom: CsmConstants.PADDING_MEDIUM),
      decoration: BoxDecoration(
        border: Border.all(
          color: effectiveBorderColor,
          width: CsmConstants.BORDER_WIDTH,
        ),
        borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_LARGE),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: widget.title,
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          iconColor: effectiveBorderColor,
          collapsedIconColor: effectiveBorderColor,
          children: [
            Padding(
              padding: const EdgeInsets.all(CsmConstants.PADDING_MEDIUM),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}