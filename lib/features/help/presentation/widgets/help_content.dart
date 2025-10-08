import 'package:flutter/material.dart';

import '../../domain/models/help_section.dart';

/// Widget for displaying help content
class HelpContentWidget extends StatelessWidget {
  final HelpSectionModel sectionData;

  const HelpContentWidget({super.key, required this.sectionData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome banner for getting started
          if (sectionData.section == HelpSection.gettingStarted)
            _buildWelcomeBanner(context),

          // Content based on section type
          ...sectionData.content.map(
            (content) => _buildContentItem(context, content),
          ),

          // Quick actions for getting started
          if (sectionData.section == HelpSection.gettingStarted)
            _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // KFU Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 32),
          ),

          const SizedBox(height: 16),

          Text(
            'مرحباً بك في مساعد كفو!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'مساعد ذكي مصمم خصيصاً لطلبة جامعة الملك فيصل لمساعدتك في الشؤون الأكاديمية والدراسية.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem(BuildContext context, HelpContent content) {
    switch (content.type) {
      case 'text':
        return _buildTextContent(context, content as HelpTextContent);
      case 'step':
        return _buildStepContent(context, content as HelpStepContent);
      case 'feature':
        return _buildFeatureContent(context, content as HelpFeatureContent);
      case 'faq':
        return _buildFAQContent(context, content as HelpFAQContent);
      case 'example':
        return _buildExampleContent(context, content as HelpExampleContent);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextContent(BuildContext context, HelpTextContent content) {
    TextStyle? textStyle;

    switch (content.style) {
      case 'title':
        textStyle = Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);
        break;
      case 'subtitle':
        textStyle = Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);
        break;
      case 'note':
        textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.primary,
        );
        break;
      default:
        textStyle = Theme.of(context).textTheme.bodyMedium;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Text(content.text, style: textStyle),
    );
  }

  Widget _buildStepContent(BuildContext context, HelpStepContent content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${content.stepNumber}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Step content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  content.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureContent(
    BuildContext context,
    HelpFeatureContent content,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Row(
        children: [
          // Feature icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForFeature(content.icon),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Feature content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  content.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQContent(BuildContext context, HelpFAQContent content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: ExpansionTile(
        title: Text(
          content.question,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content.answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleContent(
    BuildContext context,
    HelpExampleContent content,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Row(
        children: [
          // Example icon
          Text(content.icon, style: const TextStyle(fontSize: 24)),

          const SizedBox(width: 12),

          // Example text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مثال:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content.example,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.chat),
              label: const Text('ابدأ محادثة جديدة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Navigate to features section
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم توجيهك إلى قسم الميزات')),
                );
              },
              icon: const Icon(Icons.star),
              label: const Text('تعرف على الميزات'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForFeature(String iconClass) {
    switch (iconClass) {
      case 'fas fa-brain':
        return Icons.psychology;
      case 'fas fa-folder-tree':
        return Icons.folder;
      case 'fas fa-search':
        return Icons.search;
      case 'fas fa-download':
        return Icons.download;
      case 'fas fa-mobile-alt':
        return Icons.phone_android;
      case 'fas fa-shield-alt':
        return Icons.security;
      default:
        return Icons.help;
    }
  }
}
