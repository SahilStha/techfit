// DEVNOTE: see https://github.com/OkunaOrg/okuna-app/blob/682655de653fe7b64d4cb4982fa9091cac7f6b84/lib/services/httpie.dart
// For example on how to parse body into a machine/human readable format
import 'dart:io';

import 'package:dio/dio.dart';

class ApiError<T extends Response> implements Exception {
  final T? response;

  const ApiError(this.response);
}

class ApiConnectionRefusedError implements Exception {
  final SocketException socketException;

  const ApiConnectionRefusedError(this.socketException);

  @override
  String toString() {
    var address = socketException.address.toString();
    var port = socketException.port.toString();
    return 'ApiConnectionRefusedError: Connection refused on $address and port $port';
  }

  String toHumanReadableMessage() {
    return 'No internet connection.';
  }
}
