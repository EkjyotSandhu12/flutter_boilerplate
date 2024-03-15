import 'package:dio/dio.dart';

class ApiCancelTokenManager {
  static final ApiCancelTokenManager _singleton =
      ApiCancelTokenManager._internal();

  factory ApiCancelTokenManager() => _singleton;

  ApiCancelTokenManager._internal();

  //Every url request will be assigned a new token. Canceling the token will immediately force stop the request.
  //A request can be made twice. soo the same url can have 2 or more tokens as well.
  final Map<String, List<CancelToken>> _tokens = {};

  CancelToken createToken(String endPoint) {
    final token = CancelToken();
    if (_tokens.containsKey(endPoint)) {
      _tokens[endPoint]?.add(token);
    } else {
      _tokens[endPoint] = [token];
    }
    return token;
  }

  void cancelRequest(String endPoint) {
    if (_tokens.containsKey(endPoint)) {
      _tokens[endPoint]?.forEach((token) {
        _cancelToken(token);
      });
      _tokens.remove(endPoint);
    }
  }

  void cancelAllRequests() {
    _tokens.values.forEach((listOfTokens) => listOfTokens.forEach((token) {
          _cancelToken(token);
        }));
    _tokens.clear();
  }

  void removeTokenFromMap(String endPoint, CancelToken token) {
    //once the request related to the token is complete, we have to remove that token from the _tokens Map.
    if (_tokens.containsKey(endPoint)) {
      if (_tokens[endPoint]!.length <= 1) {
        _tokens.remove(endPoint);
      } else {
        _tokens[endPoint]?.removeWhere((cancelToken) =>
            token.hashCode.toString() == cancelToken.hashCode.toString());
      }
    }
  }

  void _cancelToken(CancelToken token) {
    if (!token.isCancelled) {
      token.cancel();
    }
  }
}
