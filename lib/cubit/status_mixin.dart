enum Status {
  empty,
  loading,
  fail,
  success,
}

mixin StatusMixin {
  Status _status = Status.empty;
  String? _error;

  void loading() {
    _status = Status.loading;
  }

  void fail(String errorMessage) {
    _status = Status.fail;
    _error = errorMessage;
  }

  void empty() {
    _status = Status.empty;
  }

  void success() {
    _status = Status.success;
  }

  String? get errorMessage => _error;
  bool get isLoading => _status == Status.loading;
  bool get isSuccess => _status == Status.success;
  bool get isFailed => _status == Status.fail;
  bool get isEmpty => _status == Status.empty;
}
