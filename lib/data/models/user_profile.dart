class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    required this.address,
    required this.memberSince,
    required this.loyaltyPoints,
    required this.ordersCount,
  });

  final String fullName;
  final String email;
  final String phone;
  final String city;
  final String address;
  final DateTime memberSince;
  final int loyaltyPoints;
  final int ordersCount;

  factory UserProfile.mock() {
    return UserProfile(
      fullName: 'Camille Durand',
      email: 'camille.durand@shoply.dev',
      phone: '+33 6 12 34 56 78',
      city: 'Lyon',
      address: '18 rue des Ateliers, 69002 Lyon',
      memberSince: DateTime(2023, 4, 12),
      loyaltyPoints: 1240,
      ordersCount: 17,
    );
  }
}
