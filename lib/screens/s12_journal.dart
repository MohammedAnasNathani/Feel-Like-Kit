import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../providers/session_provider.dart';
import '../services/storage_service.dart';
import '../widgets/buttons/choice_card.dart';
import '../widgets/timer_widget.dart';
import '../widgets/buttons/primary_button.dart';
import '../widgets/buttons/secondary_button.dart';

/// S12: Journal Screen (Optional, Minimal)
/// 
/// Title: "Get it out (optional)"
/// 
/// Features:
/// - 3 journal types: Brain dump / One word / Body needs
/// - Text input based on type
/// - Timer for brain dump (30s)
/// - Save to local storage
/// - Navigation: → S13 (Sustain Calm)
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String? _selectedType;
  bool _showInput = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feel Like 💩 Kit',
          style: AppTypography.appTitle.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: _showInput ? _buildInputView() : _buildSelectionView(),
        ),
      ),
    );
  }

  Widget _buildSelectionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),

        // Title
        Text(
          'Get it out',
          style: AppTypography.heading1,
        ),

        const SizedBox(height: 8),

        Text(
          '(optional)',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 32),

        // Journal type options
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ChoiceCard(
                text: 'Brain dump (30 seconds)',
                subtitle: 'Write whatever comes to mind',
                icon: Icons.edit,
                isSelected: _selectedType == 'brain_dump',
                onTap: () {
                  setState(() {
                    _selectedType = 'brain_dump';
                  });
                },
              ),
              const SizedBox(height: 12),
              ChoiceCard(
                text: 'One word for how I feel',
                subtitle: 'Just one word',
                icon: Icons.title,
                isSelected: _selectedType == 'one_word',
                onTap: () {
                  setState(() {
                    _selectedType = 'one_word';
                  });
                },
              ),
              const SizedBox(height: 12),
              ChoiceCard(
                text: 'What does my body need?',
                subtitle: 'Listen to your body',
                icon: Icons.favorite,
                isSelected: _selectedType == 'body_needs',
                onTap: () {
                  setState(() {
                    _selectedType = 'body_needs';
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Bottom buttons
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: 'Skip',
                onPressed: _handleSkip,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                text: 'Start',
                onPressed: _selectedType != null ? _handleStart : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputView() {
    final isBrainDump = _selectedType == 'brain_dump';
    final isOneWord = _selectedType == 'one_word';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),

        // Dynamic title
        Text(
          _getInputTitle(),
          style: AppTypography.heading2,
        ),

        const SizedBox(height: 24),

        // Text input
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: _textController,
                maxLines: isOneWord ? 1 : 8,
                autofocus: true,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: _getHintText(),
                  filled: true,
                  fillColor: AppColors.surfaceWarm,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              if (isBrainDump) ...[
                const SizedBox(height: 32),
                TimerWidget(
                  durationSeconds: 30,
                  onComplete: () {},
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Save and continue
        PrimaryButton(
          text: 'Save & Continue',
          onPressed: _handleSave,
        ),
      ],
    );
  }

  String _getInputTitle() {
    switch (_selectedType) {
      case 'brain_dump':
        return 'Write whatever comes out';
      case 'one_word':
        return 'One word';
      case 'body_needs':
        return 'What does your body need?';
      default:
        return 'Write';
    }
  }

  String _getHintText() {
    switch (_selectedType) {
      case 'brain_dump':
        return 'Let it all out...';
      case 'one_word':
        return 'One word...';
      case 'body_needs':
        return 'What do you need?';
      default:
        return 'Write here...';
    }
  }

  void _handleStart() {
    if (_selectedType == null) return;

    setState(() {
      _showInput = true;
    });
  }

  Future<void> _handleSave() async {
    final content = _textController.text.trim();

    if (content.isNotEmpty) {
      // Save to session
      context.read<SessionProvider>().setJournal(
            journalType: _selectedType,
            content: content,
          );

      // Save to local storage
      await StorageService().addNote(
        type: _selectedType!,
        content: content,
      );
    }

    // Navigate to Sustain Calm (S13)
    if (mounted) {
      Navigator.of(context).pushNamed('/sustain-calm');
    }
  }

  void _handleSkip() {
    // Navigate to Sustain Calm (S13)
    Navigator.of(context).pushNamed('/sustain-calm');
  }
}
