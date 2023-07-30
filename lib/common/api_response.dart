class ApiResponse<T> {
  ApiResponse({required this.status, this.statusCode, this.message, this.data});
  final Status status;
  final String? message;
  final int? statusCode;
  T? data;
}

enum Status {
  success,
  error,
  serverException,
  progressLoading,
  timeOut,
  tokenError
}

class ApiErrorResponse {
  final Status status;
  final String? message;
  final int? statusCode;
  List<Details>? details;

  ApiErrorResponse(
      {required this.status, this.statusCode, this.message, this.details});
}

class Details {
  String? type;
  String? value;
  String? msg;
  String? path;
  String? location;

  Details({this.type, this.value, this.msg, this.path, this.location});

  Details.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    msg = json['msg'];
    path = json['path'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    data['msg'] = msg;
    data['path'] = path;
    data['location'] = location;
    return data;
  }
}

class ApiResponseForList<T> {
  ApiResponseForList({required this.status, this.message, this.data});
  final Status status;
  final String? message;

  List<T>? data;

  ApiResponseForList<T> copyWith({
    Status? status,
    String? message,
    List<T>? data,
  }) {
    return ApiResponseForList<T>(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
