import 'package:flutter/material.dart';
import '../../domain/models/folder_icon.dart';
import '../../../../core/theme/icons.dart';

/// مكون اختيار أيقونة المجلد
///
/// يعرض شبكة من الأيقونات حسب الفئة
class FolderIconPickerWidget extends StatefulWidget {
  final FolderIcon? selectedIcon;
  final ValueChanged<FolderIcon>? onIconSelected;
  final IconCategory? initialCategory;

  const FolderIconPickerWidget({
    super.key,
    this.selectedIcon,
    this.onIconSelected,
    this.initialCategory,
  });

  @override
  State<FolderIconPickerWidget> createState() => _FolderIconPickerWidgetState();
}

class _FolderIconPickerWidgetState extends State<FolderIconPickerWidget> {
  IconCategory _selectedCategory = IconCategory.general;
  FolderIcon? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? IconCategory.general;
    _selectedIcon = widget.selectedIcon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // تبويبات الفئات
        _buildCategoryTabs(theme, isSmallScreen),
        const SizedBox(height: 16),
        // شبكة الأيقونات
        Expanded(
          child: _buildIconGrid(theme, isSmallScreen),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(ThemeData theme, bool isSmallScreen) {
    return SizedBox(
      height: isSmallScreen ? 45 : 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: IconCategory.values.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 3 : 4),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                category.arabicName,
                style: TextStyle(fontSize: isSmallScreen ? 11 : null),
              ),
              labelStyle: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontSize: isSmallScreen ? 11 : null,
              ),
              selectedColor: theme.colorScheme.primaryContainer,
              avatar: Icon(
                AppIcons.getIcon(category.categoryIcon),
                size: isSmallScreen ? 16 : 18,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconGrid(ThemeData theme, bool isSmallScreen) {
    final icons = FolderIconManager.getIconsByCategory(_selectedCategory);
    final crossAxisCount = isSmallScreen ? 3 : 4;
    final spacing = isSmallScreen ? 6.0 : 8.0;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final icon = icons[index];
        final isSelected = _selectedIcon?.id == icon.id;

        return InkWell(
          onTap: () {
            setState(() => _selectedIcon = icon);
            widget.onIconSelected?.call(icon);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon.iconData,
                  size: isSmallScreen ? 24 : 32,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  icon.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                    fontSize: isSmallScreen ? 9 : null,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

