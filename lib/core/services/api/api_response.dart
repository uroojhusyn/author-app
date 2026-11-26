class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, List<String>>? validationErrors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.validationErrors,
  });

  factory ApiResponse.success(T data, [String? message]) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.error(String message, [Map<String, List<String>>? validationErrors]) {
    return ApiResponse(
      success: false,
      message: message,
      validationErrors: validationErrors,
    );
  }
}
