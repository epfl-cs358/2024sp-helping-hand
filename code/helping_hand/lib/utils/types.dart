import "dart:math" as math;

typedef FutureVoidCallback = Future<void> Function();

enum SimpleRequestState {
  still,
  pending,
  valid,
}

enum RequestState {
  still,
  pending,
  valid,
  invalid,
}

int clampInt(int min, int value, int max) =>
    math.min(math.max(value, min), max);
