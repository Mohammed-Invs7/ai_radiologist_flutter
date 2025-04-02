// lib/data/models/user_model.dart
class UserRegister {
  final String email;
  final String password;
  final String passwordConfirm;
  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;

  UserRegister({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "password_confirm": passwordConfirm,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "date_of_birth": dateOfBirth,
    };
  }
}
