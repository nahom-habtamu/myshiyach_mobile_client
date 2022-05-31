import '../contracts/token_service.dart';

class ExtractToken {
  final TokenService repository;

  ExtractToken(this.repository);

  Map<String, dynamic> call(String token) {
    var result = repository.extractToken(token);
    return result;
  }
}
