class SingInViewModel {
  String? name;
  String? email;
  String? username;
  String? password;
  String? confirmPassword;

  SingInViewModel({
    this.name,
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
  });

  SingInViewModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    return data;
  }
}
