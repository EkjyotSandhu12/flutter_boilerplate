import 'dart:async';

class Debounce {
  Timer? _timer;
  Duration debounceDuration;
  Function function;

  Debounce({required this.debounceDuration, required this.function});

  execute() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(debounceDuration, () {
      function();
    });
  }
}
