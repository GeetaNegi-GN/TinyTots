import 'package:flutter/material.dart';
import '../data/tracing_data.dart';
import '../localization/app_localizations.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/playground_background.dart';
import 'tracing_screen.dart';

class NumberSelectionScreen extends StatefulWidget {
  const NumberSelectionScreen({super.key});

  @override
  State<NumberSelectionScreen> createState() => _NumberSelectionScreenState();
}

class _NumberSelectionScreenState extends State<NumberSelectionScreen> {
  Set<String> _practiced = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final saved = await ProgressService.loadTracingProgress('numbers');
    if (mounted) setState(() => _practiced = saved);
  }

  @override
  Widget build(BuildContext context) {
    final dataset = getNumberTracingData();

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
                  AppLocalizations.tr('tracing.numbers.title'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.navy,
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
                  maxCrossAxisExtent: 110,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final item = dataset[index];
                  final seen = _practiced.contains(item.id);

                  return Material(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(24),
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
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.displayChar,
                                  style: const TextStyle(
                                    fontSize: 38,
                                    color: AppTheme.navy,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                if (item.count != null && item.count! > 0)
                                  Text(
                                    '★ ' * item.count!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.navy,
                                    ),
                                  ),
                              ],
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
