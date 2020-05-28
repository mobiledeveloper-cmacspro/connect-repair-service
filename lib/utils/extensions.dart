import 'dart:async';

extension SafeSink<T> on StreamController<T> {
  void sinkAddSafe(T value) {
    if (!this.isClosed) this?.sink?.add(value);
  }
}

extension StringExtension on String {
  String toCapitalize() {
    return this.trim().isNotEmpty
        ? this.trim().replaceFirst(
            this.substring(0, 1), this.substring(0, 1).toUpperCase())
        : this;
  }
}
