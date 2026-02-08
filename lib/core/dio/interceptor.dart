import 'package:dio/dio.dart';

class RequestInterceptor extends Interceptor {
  final Map<String, String>? headers;
  RequestInterceptor({this.headers});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        handler.reject(ConnectionTimeOutException(err.requestOptions));
        break;

      case DioExceptionType.sendTimeout:
        handler.reject(SendTimeOutException(err.requestOptions));
        break;

      case DioExceptionType.receiveTimeout:
        handler.reject(ReceiveTimeOutException(err.requestOptions));
        break;

      case DioExceptionType.connectionError:
        handler.reject(ReceiveTimeOutException(err.requestOptions));
        break;

      case DioExceptionType.badResponse:
        if (err.response?.statusCode == 401 &&
            err.response?.data['message'] == 'Unauthorized!') {
          // Xử lý lỗi 401 (Unauthorized) nếu cần
        } else {
          handler.reject(
            BadResponseException(err.requestOptions, err.response),
          );
        }
        break;

      case DioExceptionType.badCertificate:
        handler.reject(BadCertificateException(err.requestOptions));
        break;

      case DioExceptionType.cancel:
        handler.reject(CancelException(err.requestOptions));
        break;

      case DioExceptionType.unknown:
        handler.reject(UnknownException(err.requestOptions));
        break;
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}

class ConnectionTimeOutException extends DioException {
  ConnectionTimeOutException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Hết thời gian kết nối, vui lòng thử lại!';
  }
}

class SendTimeOutException extends DioException {
  SendTimeOutException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Hết thời gian gửi yêu cầu, vui lòng thử lại!';
  }
}

class ReceiveTimeOutException extends DioException {
  ReceiveTimeOutException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Hết thời gian nhận dữ liệu, vui lòng thử lại!';
  }
}

class BadResponseException extends DioException {
  BadResponseException(RequestOptions r, Response? response)
    : super(requestOptions: r, response: response);

  @override
  String toString() {
    return 'Phản hồi không hợp lệ, vui lòng thử lại!';
  }
}

// Thêm các lớp mới cho các loại lỗi còn thiếu
class BadCertificateException extends DioException {
  BadCertificateException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Chứng chỉ không hợp lệ, vui lòng kiểm tra kết nối!';
  }
}

class CancelException extends DioException {
  CancelException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Yêu cầu đã bị hủy, vui lòng thử lại!';
  }
}

class UnknownException extends DioException {
  UnknownException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Lỗi không xác định, vui lòng thử lại!';
  }
}
