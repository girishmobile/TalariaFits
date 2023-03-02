class FieldValidator {
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  static String? validatePasswordSignup(String? value) {
    if (value!.isEmpty) return "Enter Password";
    if (value.length < 6) {
      return "Password should consists of minimum 6 character";
    }
    if (!RegExp(r"^(?=.*?[0-9])").hasMatch(value)) {
      return 'Password should include at least 1 number';
    }
    if (!RegExp(r"^(?=.*?[A-Z])").hasMatch(value)) {
      return 'Password should include at least 1 upper case character';
    }
    return null;
  }

  static String? validateEmailWithoutPhone(String? value) {
    if (value!.isEmpty) {
      return 'Email is Required';
    }
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Please enter a valid email Address';
    }

    return null;
  }

  static String? validateFirstName(String? value) {
    if (value!.isEmpty) {
      return 'First Name is Required';
    }

    if (!RegExp(r"^[A-Za-z-]{2,25}$").hasMatch(value)) {
      return 'Invalid name';
    }

    return null;
  }

  static String? validateSurName(String? value) {
    if (value!.isEmpty) {
      return 'Surname is Required';
    }

    if (!RegExp(r"^[A-Za-z-]{2,25}$").hasMatch(value)) {
      return 'Invalid name';
    }

    return null;
  }
}
