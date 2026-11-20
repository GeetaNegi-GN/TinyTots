import 'package:flutter/material.dart';
import '../data/tracing_data.dart';
import '../localization/app_localizations.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/playground_background.dart';
import 'tracing_screen.dart';

class LetterSelectionScreen extends StatefulWidget {
  const LetterSelectionScreen({super.key});

  @override
  State<LetterSelectionScreen> createState() => _LetterSelectionScreenState();
}

class _LetterSelectionScreenState extends State<LetterSelectionScreen> {
  bool _isUppercase = true;
  Set<String> _practiced = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final type = _isUppercase ? 'upper' : 'lower';
    final saved = await ProgressService.loadTracingProgress(type);
    if (mounted) setState(() => _practiced = saved);
  }

  void _toggleCase(bool upper) {
    if (_isUppercase == upper) return;
    setState(() {
      _isUppercase = upper;
    });
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final dataset = _isUppercase
        ? getUppercaseLetterTracingData()
        : getLowercaseLetterTracingData();

    return PlaygroundBackground(
      showHills: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                BouncyButton(
                  color: AppTheme.softWhite,
                  borderRadius: 20,
                  padding: const EdgeInsets.all(10),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_rounded, color: AppTheme.navy),
                ),
                const SizedBox(width: 14),
                Text(
                  AppLocalizations.tr('tracing.letters.title'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navy,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Uppercase / Lowercase Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: BouncyButton(
                    color: _isUppercase ? AppTheme.skyBlue : AppTheme.softWhite,
                    borderRadius: 22,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    onTap: () => _toggleCase(true),
                    child: Center(
                      child: Text(
                        AppLocalizations.tr('tracing.uppercase'),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BouncyButton(
                    color: !_isUppercase ? AppTheme.skyBlue : AppTheme.softWhite,
                    borderRadius: 22,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    onTap: () => _toggleCase(false),
                    child: Center(
                      child: Text(
                        AppLocalizations.tr('tracing.lowercase'),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: GridView.builder(
                itemCount: dataset.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 95,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final item = dataset[index];
                  final seen = _practiced.contains(item.id);

                  return Material(
                    color: AppTheme.mintGreen,
                    borderRadius: BorderRadius.circular(22),
                    elevation: 3,
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TracingScreen(
                              character: item,
                              dataset: dataset,
                              currentIndex: index,
                            ),
                          ),
                        );
                        _loadProgress();
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              item.displayChar,
                              style: TextStyle(
                                fontSize: _isUppercase ? 38 : 34,
                                color: AppTheme.navy,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (seen)
                            const Positioned(
                              right: 6,
                              top: 5,
                              child: Text('⭐', style: TextStyle(fontSize: 14)),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
