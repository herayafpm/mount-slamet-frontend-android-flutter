import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String userNama;
  @HiveField(1)
  String userEmail;
  @HiveField(2)
  String userAlamat;
  @HiveField(3)
  String userNoTelp;
  @HiveField(4)
  String userNoTelpOt;
  @HiveField(5)
  String role;
  @HiveField(6)
  bool isAdmin;
  @HiveField(7)
  String token;
  UserModel(
      {this.userNama = "",
      this.userEmail = "",
      this.userAlamat = "",
      this.userNoTelp = "",
      this.userNoTelpOt = "",
      this.role = "user",
      this.isAdmin = false,
      this.token = ""});

  factory UserModel.createFromJson(Map<String, dynamic> json) {
    return UserModel(
      userNama: json['user_nama'],
      userEmail: json['user_email'],
      userAlamat: json['user_alamat'] ?? "",
      userNoTelp: json['user_no_telp'] ?? "",
      userNoTelpOt: json['user_no_telp_ot'] ?? "",
      role: json['role'] ?? "user",
      isAdmin: json['is_admin'] ?? false,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_nama'] = this.userNama;
    data['user_alamat'] = this.userAlamat;
    data['user_no_telp'] = this.userNoTelp;
    data['user_no_telp_ot'] = this.userNoTelpOt;
    return data;
  }
}
