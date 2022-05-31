import 'package:jwt_decode/jwt_decode.dart';
import '../../domain/contracts/token_service.dart';

class TokenRepository extends TokenService {
  @override
  Map<String, dynamic> extractToken(String token) {
    return Jwt.parseJwt(token);
  }
}
