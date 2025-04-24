import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;

  final String? leetcodelink;
  final String? gfglink;
  final String? codeforceslink;
  final String? codecheflink;
  final String photo;

  final String type;
  final int totalQuestions;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.leetcodelink,
    this.gfglink,
    this.codeforceslink,
    this.codecheflink,
    this.totalQuestions = 0,
    required this.photo,
    required this.type,
    required this.token,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? leetcodelink,
    String? gfglink,
    String? codeforceslink,
    String? codecheflink,
    String? photo,
    int totalQuestions = 0,
    String? type,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      leetcodelink: leetcodelink ?? this.leetcodelink,
      gfglink: gfglink ?? this.gfglink,
      codeforceslink: codeforceslink ?? this.codeforceslink,
      codecheflink: codecheflink ?? this.codecheflink,
      photo: photo ?? this.photo,
      type: type ?? this.type,
      totalQuestions: this.totalQuestions,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'leetcodelink': leetcodelink,
      'gfglink': gfglink,
      'codeforceslink': codeforceslink,
      'codecheflink': codecheflink,
      'profilePhoto': photo,
      'totalQuestions': totalQuestions,
      'type': type,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      leetcodelink: map['leetcodelink']?.toString() ?? '',
      gfglink: map['gfglink']?.toString() ?? '',
      codeforceslink: map['codeforceslink']?.toString() ?? '',
      codecheflink: map['codecheflink']?.toString() ?? '',
      totalQuestions: map['totalQuestions']?.toInt() ?? 0,
      photo: map['photo']?.toString() ?? '',
      type: map['type']?.toString() ?? 'user',
      token: map['token']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
