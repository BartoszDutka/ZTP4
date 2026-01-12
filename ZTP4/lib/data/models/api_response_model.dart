/// Model odpowiedzi API
/// Odpowiada strukturze ApiResponse z Lab 1
class ApiResponseModel<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? errorCode;

  ApiResponseModel({
    required this.success,
    this.data,
    this.message,
    this.errorCode,
  });

  /// Tworzy ApiResponseModel z mapy JSON
  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponseModel(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
      errorCode: json['errorCode'] as int?,
    );
  }
}
