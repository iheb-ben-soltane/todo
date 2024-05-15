class User_ {
  String id = '';
  String name = ' ';
  String lastName = '';
  String email = '';
  String password = '';
  String profileImage = '';

  User_(
    String usermail,
    String username,
    String userlastname,
    String userProfileImage,
  ) {
    this.name = username;
    this.lastName = userlastname;
    this.email = usermail;
    this.profileImage = userProfileImage;
  }

  User_.empty();

  User_.fromMap(Map<String, dynamic> map) {
    id = map["Id"] ?? '';
    name = map['name'] ?? '';
    lastName = map['lastName'] ?? '';
    email = map['email'] ?? '';
    profileImage = map['profileImage'] ?? '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = this.id;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['profileImage'] = this.profileImage;

    return data;
  }
}
