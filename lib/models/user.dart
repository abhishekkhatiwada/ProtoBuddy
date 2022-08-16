class User {
  late String email;
  late String imageUrl;
  late String userId;
  late String username;

  User(
      {required this.email,
      required this.imageUrl,
      required this.username,
      required this.userId});

  factory User.formJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        imageUrl: json['imageUrl'],
        username: json['username'],
        userId: json['userId']);
  }
}
