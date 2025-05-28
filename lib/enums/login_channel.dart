enum LoginChannel {
  google,
  naver,
  kakao,
  apple,
}

extension LoginChannelCode on LoginChannel {
  int get code {
    switch (this) {
      case LoginChannel.google:
        return 1;
      case LoginChannel.naver:
        return 2;
      case LoginChannel.kakao:
        return 3;
      case LoginChannel.apple:
        return 4;
    }
  }

  static LoginChannel fromCode(int code) {
    switch (code) {
      case 1:
        return LoginChannel.google;
      case 2:
        return LoginChannel.naver;
      case 3:
        return LoginChannel.kakao;
      case 4:
        return LoginChannel.apple;
      default:
        throw ArgumentError('Invalid login channel code: $code');
    }
  }
}
