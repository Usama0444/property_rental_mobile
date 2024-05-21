import 'package:get/get.dart';

validateUsername(String value) {
  if (value.isEmpty) {
    return 'Enter user name.';
  }
  if (value.length < 3 || value.length > 20) {
    return 'Username must be between 3 and 20 characters long.';
  }
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
    return 'Username can only contain letters, numbers, and underscores.';
  }
  return null;
}

isUsernameValid(String value) {
  if (value.isEmpty) {
    return 'Enter your name.';
  }
  return null;
}

isEmailValid(String value) {
  if (value.isEmpty) {
    return "Enter your email.";
  } else if (!GetUtils.isEmail(value)) {
    return "Enter valid email.";
  }
  return null;
}

isPhoneValid(String value) {
  if (value.isEmpty) {
    return "Enter your phone no.";
  } else if (!GetUtils.isPhoneNumber(value)) {
    return "Enter valid phone no.";
  }
  return null;
}

isPasswordValid(String value) {
  if (value.isEmpty) {
    return "Enter your password.";
  } else if (value.length < 8) {
    return "Password should be greater than 8.";
  } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character';
  } else if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  return null;
}

isNewPasswordValid(
  String value,
) {
  if (value.isEmpty) {
    return "Enter your new password.";
  } else if (value.length < 8) {
    return "Password should be greater than 8.";
  }
  return null;
}

isConfirmPasswordValid(String value, String password) {
  if (value.isEmpty) {
    return "Enter confirm password.";
  } else if (value.length < 8) {
    return "Password should be greater than 8.";
  } else if (value != password) {
    return "Password doesn't match!";
  }
  return null;
}
