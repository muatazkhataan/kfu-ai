import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/l10n.dart';

/// Feedback screen widget
class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedType = 'bug';
  String _selectedPriority = 'medium';
  final List<String> _attachedImages = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(theme),

              const SizedBox(height: 24),

              // Personal Information
              _buildSection(
                theme: theme,
                title: 'المعلومات الشخصية',
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: context.l10n.feedbackName,
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'يرجى إدخال الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: context.l10n.feedbackEmail,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value!)) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Feedback Type and Priority
              _buildSection(
                theme: theme,
                title: 'تفاصيل الملاحظة',
                children: [
                  _buildDropdownField(
                    theme: theme,
                    label: context.l10n.feedbackType,
                    icon: Icons.category_outlined,
                    value: _selectedType,
                    items: const [
                      DropdownMenuItem(
                        value: 'bug',
                        child: Text('مشكلة تقنية'),
                      ),
                      DropdownMenuItem(
                        value: 'feature',
                        child: Text('اقتراح ميزة'),
                      ),
                      DropdownMenuItem(
                        value: 'improvement',
                        child: Text('تحسين'),
                      ),
                      DropdownMenuItem(value: 'other', child: Text('أخرى')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value ?? 'bug';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    theme: theme,
                    label: context.l10n.feedbackPriority,
                    icon: Icons.priority_high,
                    value: _selectedPriority,
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('منخفضة')),
                      DropdownMenuItem(value: 'medium', child: Text('متوسطة')),
                      DropdownMenuItem(value: 'high', child: Text('عالية')),
                      DropdownMenuItem(value: 'urgent', child: Text('عاجلة')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value ?? 'medium';
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Subject and Message
              _buildSection(
                theme: theme,
                title: 'المحتوى',
                children: [
                  _buildTextField(
                    controller: _subjectController,
                    label: context.l10n.feedbackSubject,
                    icon: Icons.subject,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'يرجى إدخال موضوع الملاحظة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _messageController,
                    label: context.l10n.feedbackMessage,
                    icon: Icons.message_outlined,
                    maxLines: 5,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'يرجى إدخال وصف الملاحظة';
                      }
                      if (value!.length < 10) {
                        return 'يرجى إدخال وصف مفصل (10 أحرف على الأقل)';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Image Attachments
              _buildSection(
                theme: theme,
                title: context.l10n.feedbackAttachImages,
                children: [_buildImageAttachments(theme)],
              ),

              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(theme),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.feedbackTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'نقدر ملاحظاتك واقتراحاتك لتحسين التطبيق',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build section wrapper
  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  /// Build text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
      ),
    );
  }

  /// Build dropdown field
  Widget _buildDropdownField({
    required ThemeData theme,
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
      ),
      items: items,
    );
  }

  /// Build image attachments section
  Widget _buildImageAttachments(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'الصور المرفقة (${_attachedImages.length}/5)',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Image grid
        if (_attachedImages.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _attachedImages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withAlpha(76),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        _attachedImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _attachedImages.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: theme.colorScheme.onError,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
        ],

        // Add image button
        if (_attachedImages.length < 5)
          InkWell(
            onTap: _addImage,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline.withAlpha(128),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'إضافة صورة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _saveDraft,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(context.l10n.feedbackSaveDraft),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _submitFeedback,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(context.l10n.feedbackSubmit),
          ),
        ),
      ],
    );
  }

  /// Add image
  void _addImage() {
    // TODO: Implement image picker
    setState(() {
      _attachedImages.add('assets/images/placeholder.png');
    });
  }

  /// Save draft
  void _saveDraft() {
    // TODO: Implement draft saving
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ المسودة')));
  }

  /// Submit feedback
  void _submitFeedback() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement feedback submission
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال الملاحظة بنجاح')));

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      setState(() {
        _attachedImages.clear();
        _selectedType = 'bug';
        _selectedPriority = 'medium';
      });
    }
  }
}
