class UserModel {
  int? userID = 0;
  String? userName = "";
  String? email = "";
  String? password = "";

  UserModel({
    this.userID,
    this.userName,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'user_id': userID, 'user_name': userName, 'email': email, 'password': password};
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    userID = map['user_id'];
    userName = map['user_name'];
    email = map['email'];
    password = map['password'];
  }
}
