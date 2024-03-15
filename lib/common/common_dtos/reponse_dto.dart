class ResponseDto {
  dynamic data;
  late bool success;
  late int responseCode;

  ResponseDto(
    this.data,
    this.success,
    this.responseCode,
  );

  ResponseDto.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = json['data'];
    }
    success = json['success'] ?? false;
    responseCode = json['status'] ?? 0;
  }
}
