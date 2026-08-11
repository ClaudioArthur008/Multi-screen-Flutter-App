class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
  });
}
