import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_tots/services/progress_service.dart';

void main() {
  test('LearningProgress stars count equals set length', () {
    const progress = LearningProgress(
      explored: {'A', 'B', 'C'},
      lastIndex: 2,
    );
    expect(progress.stars, 3);
  });

  test('ProgressService fallback load and save', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final initial = await ProgressService.load();
    expect(initial, isA<LearningProgress>());

    const updated = LearningProgress(
      explored: {'A', 'B'},
      lastIndex: 1,
    );
    await ProgressService.save(updated);

    final loaded = await ProgressService.load();
    expect(loaded.explored, containsAll(['A', 'B']));
    expect(loaded.lastIndex, 1);
  });
}
