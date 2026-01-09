import 'package:flutter/material.dart';
import '../models/Recipe.dart';
import '../config/Colors.dart';
import '../config/Constants.dart';

class RecipeCardFull extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect; // para seleccionar la receta para un meal
  final bool showActions;
  final bool showNutrition; // muestra info nutricional
  
  const RecipeCardFull({
    Key? key,
    required this.recipe,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSelect,
    this.showActions = false,
    this.showNutrition = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: CsmConstants.PADDING_MEDIUM),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetRosaRecetas(isDark),
          width: CsmConstants.BORDER_WIDTH,
        ),
        borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_LARGE),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            _GetMealTypeIcon(recipe.mealType),
            color: CsmColors.GetRosaRecetas(isDark),
            size: 32,
          ),
          title: Text(
            recipe.name,
            style: TextStyle(
              color: CsmColors.GetRosaRecetas(isDark),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                recipe.mealType.toUpperCase(),
                style: TextStyle(
                  color: CsmColors.GetVerdeDieta(isDark),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 14,
                    color: CsmColors.GetTexto(isDark).withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    recipe.GetFormattedTime(),
                    style: TextStyle(
                      color: CsmColors.GetTexto(isDark).withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.attach_money,
                    size: 14,
                    color: CsmColors.GetAmarilloCompras(isDark),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    recipe.GetFormattedCostPerServing(),
                    style: TextStyle(
                      color: CsmColors.GetAmarilloCompras(isDark),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: showActions
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: CsmColors.GetRosaRecetas(isDark),
                        ),
                        onPressed: onEdit,
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: CsmColors.GetRojoImportante(isDark),
                        ),
                        onPressed: onDelete,
                      ),
                  ],
                )
              : null,
          children: [
            Padding(
              padding: const EdgeInsets.all(CsmConstants.PADDING_MEDIUM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // descripcion
                  Text(
                    recipe.description,
                    style: TextStyle(
                      color: CsmColors.GetTexto(isDark),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // info general
                  _BuildInfoRow(isDark),
                  const SizedBox(height: 16),
                  
                  // informacion nutricional
                  if (showNutrition) ...[
                    _BuildNutritionInfo(isDark),
                    const SizedBox(height: 16),
                  ],
                  
                  // ingredientes
                  Text(
                    'Ingredientes:',
                    style: TextStyle(
                      color: CsmColors.GetNaranjaIngredientes(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map((ingredient) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            color: CsmColors.GetNaranjaIngredientes(isDark),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ingredient.GetFullDescription(),
                            style: TextStyle(
                              color: CsmColors.GetTexto(isDark),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        if (ingredient.estimatedPrice != null)
                          Text(
                            ingredient.GetFormattedPrice(),
                            style: TextStyle(
                              color: CsmColors.GetAmarilloCompras(isDark),
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: 16),
                  
                  // pasos de preparacion
                  Text(
                    'Preparación:',
                    style: TextStyle(
                      color: CsmColors.GetRosaRecetas(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...recipe.steps.asMap().entries.map((entry) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CsmColors.GetRosaRecetas(isDark).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_MEDIUM),
                      border: Border.all(
                        color: CsmColors.GetRosaRecetas(isDark).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: CsmColors.GetRosaRecetas(isDark),
                          child: Text(
                            '${entry.key + 1}',
                            style: TextStyle(
                              color: CsmColors.GetFondo(isDark),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: CsmColors.GetTexto(isDark),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                  
                  // tags
                  if (recipe.tags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipe.tags.map((tag) => Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: CsmColors.GetVerdeDieta(isDark).withOpacity(0.2),
                        side: BorderSide(
                          color: CsmColors.GetVerdeDieta(isDark),
                          width: 1,
                        ),
                      )).toList(),
                    ),
                  ],
                  
                  // botones de accion
                  if (onTap != null || onSelect != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (onSelect != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onSelect,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Seleccionar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CsmColors.GetVerdeDieta(isDark),
                              ),
                            ),
                          ),
                        if (onTap != null && onSelect != null)
                          const SizedBox(width: 12),
                        if (onTap != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onTap,
                              icon: const Icon(Icons.restaurant),
                              label: const Text('Ver Detalles'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CsmColors.GetRosaRecetas(isDark),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // construye la fila de informacion general
  Widget _BuildInfoRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _BuildInfoBox(
            'Prep.',
            '${recipe.preparationTimeMinutes} min',
            Icons.kitchen,
            isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _BuildInfoBox(
            'Cocción',
            '${recipe.cookingTimeMinutes} min',
            Icons.local_fire_department,
            isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _BuildInfoBox(
            'Porciones',
            '${recipe.servings}',
            Icons.restaurant,
            isDark,
          ),
        ),
      ],
    );
  }
  
  // construye una caja de informacion
  Widget _BuildInfoBox(String label, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CsmColors.GetRosaRecetas(isDark).withOpacity(0.1),
        borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_SMALL),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: CsmColors.GetRosaRecetas(isDark),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: CsmColors.GetTexto(isDark).withOpacity(0.7),
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: CsmColors.GetTexto(isDark),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  // construye informacion nutricional
  Widget _BuildNutritionInfo(bool isDark) {
    final nutrition = recipe.GetNutritionPerServing();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CsmColors.GetVerdeDieta(isDark).withOpacity(0.1),
        borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_MEDIUM),
        border: Border.all(
          color: CsmColors.GetVerdeDieta(isDark).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Nutricional (por porción)',
            style: TextStyle(
              color: CsmColors.GetVerdeDieta(isDark),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BuildNutrientBox('Calorías', '${nutrition['calories']?.toStringAsFixed(0)} kcal', isDark),
              _BuildNutrientBox('Proteína', '${nutrition['protein']?.toStringAsFixed(1)}g', isDark),
              _BuildNutrientBox('Carbos', '${nutrition['carbs']?.toStringAsFixed(1)}g', isDark),
              _BuildNutrientBox('Grasas', '${nutrition['fats']?.toStringAsFixed(1)}g', isDark),
            ],
          ),
        ],
      ),
    );
  }
  
  // construye una caja de nutriente
  Widget _BuildNutrientBox(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: CsmColors.GetTexto(isDark),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: CsmColors.GetTexto(isDark).withOpacity(0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
  
  // obtiene el icono segun el tipo de comida
  IconData _GetMealTypeIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'desayuno':
        return Icons.wb_sunny;
      case 'comida':
        return Icons.lunch_dining;
      case 'cena':
        return Icons.nightlight_round;
      default:
        return Icons.restaurant;
    }
  }
}