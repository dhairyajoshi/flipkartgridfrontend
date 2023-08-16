class UserModel {
  String id;
  String name;
  String email;
  String? phone;
  double account;
  String walletAddress;
  double supercoins;
  String? referralCode;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.account,
    required this.walletAddress,
    required this.supercoins,
    this.referralCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      account: json['account'],
      walletAddress: json['walletAddress'],
      supercoins: json['supercoins'],
      referralCode: json['referral_code'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'account': account,
      'walletAddress': walletAddress,
      'supercoins': supercoins,
      'referral_code': referralCode,
    };
  }
}
