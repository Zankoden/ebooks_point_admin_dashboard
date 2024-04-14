class User {
  bool? success;
  List<Users>? users;
  String? message;

  User({this.success, this.users, this.message});

  User.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Users {
  String? userId;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? phoneNumber;
  String? password;
  String? type;
  String? profileImageUrl;
  String? membershipId;

  Users(
      {this.userId,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.phoneNumber,
      this.password,
      this.type,
      this.profileImageUrl,
      this.membershipId});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    password = json['password'];
    type = json['type'];
    profileImageUrl = json['profile_image_url'];
    membershipId = json['membership_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['password'] = password;
    data['type'] = type;
    data['profile_image_url'] = profileImageUrl;
    data['membership_id'] = membershipId;
    return data;
  }
}
