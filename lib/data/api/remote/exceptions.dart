class ServerException implements Exception {
  String message;
  int statusCode;
  int customStatusCode;

  ServerException.fromJson(Map<String, dynamic> json) {
    this.statusCode = json["statusCode"];
    this.customStatusCode = json["customStatusCode"];
    this.message = json["message"];
  }
}