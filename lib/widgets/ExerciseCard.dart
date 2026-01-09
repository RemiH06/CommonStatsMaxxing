import 'package:flutter/material.dart';
import '../models/Exercise.dart';
import '../config/Colors.dart';
import '../config/Constants.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int? number; // numero del ejercicio en la lista
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions; // muestra botones de editar/eliminar
  
  const ExerciseCard({
    Key? key,
    required this.exercise,
    this.number,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: CsmConstants.PADDING_MEDIUM),
      decoration: BoxDecoration(
        border: Border.all(
          color: CsmColors.GetAzulRutina(isDark),
          width: CsmConstants.BORDER_WIDTH,
        ),
        borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_LARGE),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: number != null
              ? CircleAvatar(
                  backgroundColor: CsmColors.GetAzulRutina(isDark),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: CsmColors.GetFondo(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              : Icon(
                  Icons.fitness_center,
                  color: CsmColors.GetAzulRutina(isDark),
                ),
          title: Text(
            exercise.name,
            style: TextStyle(
              color: CsmColors.GetAzulRutina(isDark),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            exercise.GetShortDescription(),
            style: TextStyle(
              color: CsmColors.GetTexto(isDark),
              fontSize: 14,
            ),
          ),
          trailing: showActions
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: CsmColors.GetAzulRutina(isDark),
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
                  // descripcion del ejercicio
                  Text(
                    exercise.description,
                    style: TextStyle(
                      color: CsmColors.GetTexto(isDark),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // detalles en grid
                  _BuildDetailsGrid(isDark),
                  
                  // equipo necesario
                  if (exercise.equipment.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Equipo necesario:',
                      style: TextStyle(
                        color: CsmColors.GetAzulRutina(isDark),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exercise.equipment.map((item) => Chip(
                        label: Text(
                          item,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: CsmColors.GetAzulRutina(isDark).withOpacity(0.2),
                        side: BorderSide(
                          color: CsmColors.GetAzulRutina(isDark),
                          width: 1,
                        ),
                      )).toList(),
                    ),
                  ],
                  
                  // tags
                  if (exercise.tags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: exercise.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: CsmColors.GetMoradoContornos(isDark).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CsmColors.GetMoradoContornos(isDark),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: CsmColors.GetMoradoContornos(isDark),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                  
                  // boton de accion si hay onTap
                  if (onTap != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CsmColors.GetAzulRutina(isDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_MEDIUM),
                          ),
                        ),
                        child: Text(
                          'Iniciar Ejercicio',
                          style: TextStyle(
                            color: CsmColors.GetFondo(isDark),
                          ),
                        ),
                      ),
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
  
  // construye el grid de detalles
  Widget _BuildDetailsGrid(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _BuildDetailItem(
                'Área objetivo',
                exercise.targetArea,
                Icons.my_location,
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BuildDetailItem(
                'Dificultad',
                exercise.difficulty,
                Icons.signal_cellular_alt,
                isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _BuildDetailItem(
                'Series',
                '${exercise.sets}',
                Icons.repeat,
                isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BuildDetailItem(
                'Descanso',
                '${exercise.restSeconds}s',
                Icons.timer_off,
                isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _BuildDetailItem(
          'Duración total',
          exercise.GetFormattedTime(),
          Icons.timer,
          isDark,
        ),
      ],
    );
  }
  
  // construye un item de detalle
  Widget _BuildDetailItem(String label, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CsmColors.GetAzulRutina(isDark).withOpacity(0.1),
        borderRadius: BorderRadius.circular(CsmConstants.BORDER_RADIUS_MEDIUM),
        border: Border.all(
          color: CsmColors.GetAzulRutina(isDark).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: CsmConstants.ICON_SIZE_SMALL,
            color: CsmColors.GetAzulRutina(isDark),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark).withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: CsmColors.GetTexto(isDark),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}