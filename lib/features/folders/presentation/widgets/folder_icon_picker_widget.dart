import 'package:flutter/material.dart';
import '../../domain/models/folder_icon.dart';
import '../../domain/extensions/icon_category_localization_extension.dart';
import '../../domain/extensions/folder_icon_localization_extension.dart';
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
  void didUpdateWidget(FolderIconPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIcon != oldWidget.selectedIcon) {
      _selectedIcon = widget.selectedIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // تبويبات الفئات (أيقونات فقط مع tooltip)
        _buildCategoryTabs(theme, isTabletOrDesktop),
        const SizedBox(height: 16),
        // شبكة الأيقونات - تتمدد إلى أسفل بدون سكرول
        _buildIconGrid(theme, isTabletOrDesktop),
      ],
    );
  }

  Widget _buildCategoryTabs(ThemeData theme, bool isTabletOrDesktop) {
    return SizedBox(
      height: 35,
      child: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: IconCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Tooltip(
                message: category.getLocalizedName(context),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedCategory = category);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 35,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTabletOrDesktop ? 12 : 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withAlpha(64)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppIcons.getIcon(category.categoryIcon),
                            size: 18,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                          if (isTabletOrDesktop) ...[
                            const SizedBox(width: 6),
                            Text(
                              category.getLocalizedName(context),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildIconGrid(ThemeData theme, bool isTabletOrDesktop) {
    final icons = FolderIconManager.getIconsByCategory(_selectedCategory);

    // في المحمول: أيقونات فقط 50x50 - حجم ثابت تماماً
    // في التابلت/الكمبيوتر: أيقونة 100x100 مع النص تحتها - حجم ثابت تماماً
    final itemSize = isTabletOrDesktop ? 100.0 : 50.0;
    final crossAxisCount = isTabletOrDesktop ? 4 : 5;
    final spacing = isTabletOrDesktop ? 12.0 : 8.0;
    final iconIconSize = isTabletOrDesktop ? 48.0 : 28.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: itemSize, // حجم ثابت تماماً - لا تمدد
      ),
      itemCount: icons.length,
      clipBehavior: Clip.antiAlias,
      itemBuilder: (context, index) {
        final icon = icons[index];
        final isSelected = _selectedIcon?.id == icon.id;

        return SizedBox(
          width: itemSize,
          height: itemSize,
          child: InkWell(
            onTap: () {
              setState(() => _selectedIcon = icon);
              widget.onIconSelected?.call(icon);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: itemSize,
              height: itemSize,
              constraints: BoxConstraints(
                minWidth: itemSize,
                maxWidth: itemSize,
                minHeight: itemSize,
                maxHeight: itemSize,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: theme.colorScheme.primary, width: 2)
                    : null,
              ),
              child: isTabletOrDesktop
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon.iconData,
                          size: iconIconSize,
                          color: isSelected
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            icon.getLocalizedName(context),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Icon(
                        icon.iconData,
                        size: iconIconSize,
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
