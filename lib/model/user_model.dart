class UserModel {
  final String username;
  final String uid;
  final String profileImageUrl;

  final String phoneNumber;
  final String emailId;
  final String weight;
  final String height;
  final String gender;

  UserModel({
    required this.username,
    required this.uid,
    required this.profileImageUrl,

    required this.emailId,
    required this.phoneNumber,

    required this.height,
    required this.weight,
    required this.gender
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'profileImageUrl': profileImageUrl,

      'phoneNumber': phoneNumber,

      'height': height,
      'weight' : weight,
      'gender' : gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      emailId: map['emailId'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',

      height: map['height'] ?? '',
      weight: map['weight'] ?? '',
      gender: map['gender'] ?? ''
    );
  }
}