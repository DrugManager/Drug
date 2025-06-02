class UserModel {
  final String uid;
  final String userNickName;
  final int loginChannel; // 예: 1 = 구글, 2 = 이메일 등
  final String userName;
  final String subscribeDate;

  UserModel({
    required this.uid,
    required this.userNickName,
    required this.loginChannel,
    required this.userName,
    required this.subscribeDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userNickName': userNickName,
      'loginChannel': loginChannel,
      'userName': userName,
      'subscribeDate': subscribeDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      userNickName: map['userNickName'] ?? '',
      loginChannel: map['loginChannel'] ?? 0,
      userName: map['userName'] ?? '',
      subscribeDate: map['subscribeDate'] ?? '',
    );
  }
}