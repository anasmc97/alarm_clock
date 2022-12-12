class Error {
  static checkException(dynamic exception) {
    if (exception.toString().contains('SocketException')) {
      return 'NetworkError';
    } else {
      return null;
    }
  }
}
