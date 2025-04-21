class User {
  final int pk;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final int age;
  final String dateOfBirth;
  final DateTime joinDate;
  final String profileImage;

  User({
    required this.pk,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.age,
    required this.dateOfBirth,
    required this.joinDate,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      pk: json['pk'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      age: json['age'],
      dateOfBirth: json['date_of_birth'],
      joinDate: DateTime.parse(json['join_date']),
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'age': age,
      'date_of_birth': dateOfBirth,
      'join_date': joinDate.toIso8601String(),
      'profile_image': profileImage,
    };
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? profileImage,
  }) {
    return User(
      pk: pk,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      age: age,
      dateOfBirth: dateOfBirth,
      joinDate: joinDate,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
