class OrganizerModel {
  final String uid;
  final String username;
  final String password;
  String name;
  String email;
  String phone;
  String profilePic;

  OrganizerModel({
    required this.uid,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
  });

  factory OrganizerModel.fromMap(Map<String, dynamic> map, String uid) {
    return OrganizerModel(
      uid: uid,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'username': username,
    'password': password,
    'name': name,
    'email': email,
    'phone': phone,
    'profilePic': profilePic,
  };
}
