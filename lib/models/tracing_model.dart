class TracingPoint {
  const TracingPoint(this.dx, this.dy);
  final double dx;
  final double dy;
}

class TracingStroke {
  const TracingStroke({
    required this.startPoint,
    required this.endPoint,
    required this.controlPoints,
    this.arrowAngle = 0.0,
  });

  final TracingPoint startPoint;
  final TracingPoint endPoint;
  final List<TracingPoint> controlPoints;
  final double arrowAngle;
}

class TracingCharacter {
  const TracingCharacter({
    required this.id,
    required this.displayChar,
    required this.isUppercase,
    required this.strokes,
    this.associatedWord,
    this.imagePath,
    this.count,
  });

  final String id;
  final String displayChar;
  final bool isUppercase;
  final List<TracingStroke> strokes;
  final String? associatedWord;
  final String? imagePath;
  final int? count;
}
