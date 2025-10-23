import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/icons.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/models/search_filter.dart';

/// شاشة فلاتر البحث
class SearchFilterSheet extends ConsumerStatefulWidget {
  final SearchFilter currentFilter;
  final Function(SearchFilter) onApply;

  const SearchFilterSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  @override
  ConsumerState<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends ConsumerState<SearchFilterSheet> {
  late SearchFilter _workingFilter;

  @override
  void initState() {
    super.initState();
    _workingFilter = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.getIcon(AppIcon.filter),
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'فلاتر البحث',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('إعادة تعيين'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(AppIcons.getIcon(AppIcon.close)),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeFilter(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildSortByFilter(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildDateFilter(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildMessageCountFilter(theme, colorScheme),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _applyFilters,
                    child: const Text('تطبيق الفلاتر'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع المحادثات',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: SearchType.values.map((type) {
            final isSelected = _workingFilter.type == type;
            return FilterChip(
              label: Text(type.arabicName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _workingFilter = _workingFilter.copyWith(type: type);
                });
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortByFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ترتيب النتائج',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: SortBy.values.map((sortBy) {
            final isSelected = _workingFilter.sortBy == sortBy;
            return FilterChip(
              label: Text(sortBy.arabicName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _workingFilter = _workingFilter.copyWith(sortBy: sortBy);
                });
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'فترة زمنية',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (_workingFilter.hasDateFilter)
              TextButton.icon(
                onPressed: _clearDateFilter,
                icon: Icon(AppIcons.getIcon(AppIcon.close), size: 16),
                label: const Text('مسح'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'من تاريخ',
                _workingFilter.startDate,
                (date) {
                  setState(() {
                    _workingFilter = _workingFilter.copyWith(startDate: date);
                  });
                },
                theme,
                colorScheme,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDateField(
                'إلى تاريخ',
                _workingFilter.endDate,
                (date) {
                  setState(() {
                    _workingFilter = _workingFilter.copyWith(endDate: date);
                  });
                },
                theme,
                colorScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? value,
    Function(DateTime?) onChanged,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              AppIcons.getIcon(AppIcon.clock),
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value != null
                    ? '${value.day}/${value.month}/${value.year}'
                    : label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: value != null
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCountFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'عدد الرسائل',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (_workingFilter.hasMessageCountFilter)
              TextButton.icon(
                onPressed: _clearMessageCountFilter,
                icon: Icon(AppIcons.getIcon(AppIcon.close), size: 16),
                label: const Text('مسح'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'الحد الأدنى',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final count = int.tryParse(value);
                  setState(() {
                    _workingFilter = _workingFilter.copyWith(
                      minMessageCount: count,
                    );
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'الحد الأقصى',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final count = int.tryParse(value);
                  setState(() {
                    _workingFilter = _workingFilter.copyWith(
                      maxMessageCount: count,
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _workingFilter = SearchFilter.defaultFilter();
    });
  }

  void _clearDateFilter() {
    setState(() {
      _workingFilter = _workingFilter.copyWith(
        clearStartDate: true,
        clearEndDate: true,
      );
    });
  }

  void _clearMessageCountFilter() {
    setState(() {
      _workingFilter = _workingFilter.copyWith(
        clearMinMessageCount: true,
        clearMaxMessageCount: true,
      );
    });
  }

  void _applyFilters() {
    widget.onApply(_workingFilter);
  }
}
