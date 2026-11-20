import '../models/tracing_model.dart';
import 'alphabet_data.dart';

List<TracingCharacter> getUppercaseLetterTracingData() {
  return alphabetCards.map((card) {
    final id = card.id.toUpperCase();
    return TracingCharacter(
      id: id,
      displayChar: id,
      isUppercase: true,
      associatedWord: card.word,
      imagePath: card.imagePath,
      strokes: _getStandardStrokesForChar(id, true),
    );
  }).toList();
}

List<TracingCharacter> getLowercaseLetterTracingData() {
  return alphabetCards.map((card) {
    final id = card.id.toLowerCase();
    return TracingCharacter(
      id: id,
      displayChar: id,
      isUppercase: false,
      associatedWord: card.word,
      imagePath: card.imagePath,
      strokes: _getStandardStrokesForChar(id, false),
    );
  }).toList();
}

List<TracingCharacter> getNumberTracingData() {
  final numWords = ['Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
  return List.generate(10, (i) {
    final char = '$i';
    return TracingCharacter(
      id: 'num_$i',
      displayChar: char,
      isUppercase: true,
      count: i,
      associatedWord: numWords[i],
      imagePath: i > 0 ? 'assets/learning/numbers/${i}_${numWords[i].toLowerCase()}.jpg' : null,
      strokes: _getStandardStrokesForChar(char, true),
    );
  });
}

List<TracingStroke> _getStandardStrokesForChar(String char, bool isUpper) {
  // Generic structured stroke path definitions with start points, guide points, and direction arrows
  switch (char) {
    case 'A':
      return const [
        TracingStroke(startPoint: TracingPoint(0.5, 0.15), endPoint: TracingPoint(0.2, 0.85), controlPoints: [TracingPoint(0.35, 0.5)], arrowAngle: 2.4),
        TracingStroke(startPoint: TracingPoint(0.5, 0.15), endPoint: TracingPoint(0.8, 0.85), controlPoints: [TracingPoint(0.65, 0.5)], arrowAngle: 0.7),
        TracingStroke(startPoint: TracingPoint(0.3, 0.55), endPoint: TracingPoint(0.7, 0.55), controlPoints: [TracingPoint(0.5, 0.55)], arrowAngle: 0.0),
      ];
    case 'B':
      return const [
        TracingStroke(startPoint: TracingPoint(0.25, 0.15), endPoint: TracingPoint(0.25, 0.85), controlPoints: [TracingPoint(0.25, 0.5)], arrowAngle: 1.57),
        TracingStroke(startPoint: TracingPoint(0.25, 0.15), endPoint: TracingPoint(0.25, 0.5), controlPoints: [TracingPoint(0.65, 0.25)], arrowAngle: 3.14),
        TracingStroke(startPoint: TracingPoint(0.25, 0.5), endPoint: TracingPoint(0.25, 0.85), controlPoints: [TracingPoint(0.7, 0.67)], arrowAngle: 3.14),
      ];
    case 'C':
      return const [
        TracingStroke(startPoint: TracingPoint(0.75, 0.25), endPoint: TracingPoint(0.75, 0.75), controlPoints: [TracingPoint(0.2, 0.2), TracingPoint(0.2, 0.8)], arrowAngle: 3.14),
      ];
    case '1':
      return const [
        TracingStroke(startPoint: TracingPoint(0.35, 0.3), endPoint: TracingPoint(0.5, 0.15), controlPoints: [TracingPoint(0.42, 0.22)], arrowAngle: 0.7),
        TracingStroke(startPoint: TracingPoint(0.5, 0.15), endPoint: TracingPoint(0.5, 0.85), controlPoints: [TracingPoint(0.5, 0.5)], arrowAngle: 1.57),
        TracingStroke(startPoint: TracingPoint(0.3, 0.85), endPoint: TracingPoint(0.7, 0.85), controlPoints: [TracingPoint(0.5, 0.85)], arrowAngle: 0.0),
      ];
    case '0':
      return const [
        TracingStroke(startPoint: TracingPoint(0.5, 0.15), endPoint: TracingPoint(0.5, 0.15), controlPoints: [TracingPoint(0.2, 0.5), TracingPoint(0.5, 0.85), TracingPoint(0.8, 0.5)], arrowAngle: 3.14),
      ];
    default:
      return const [
        TracingStroke(startPoint: TracingPoint(0.3, 0.2), endPoint: TracingPoint(0.3, 0.8), controlPoints: [TracingPoint(0.3, 0.5)], arrowAngle: 1.57),
        TracingStroke(startPoint: TracingPoint(0.3, 0.5), endPoint: TracingPoint(0.7, 0.5), controlPoints: [TracingPoint(0.5, 0.5)], arrowAngle: 0.0),
        TracingStroke(startPoint: TracingPoint(0.7, 0.2), endPoint: TracingPoint(0.7, 0.8), controlPoints: [TracingPoint(0.7, 0.5)], arrowAngle: 1.57),
      ];
  }
}
