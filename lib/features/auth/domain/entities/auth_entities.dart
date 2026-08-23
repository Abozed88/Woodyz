class User {
  String id;
  String username;
  String fullName;
  String? avatarUrl;
  String role;
  String? bio;
  String? phone;
  String location;

  User({
    this.id = '',
    required this.username,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    this.bio,
    this.phone,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'],
      role: json['role'] ?? 'customer',
      bio: json['bio'],
      phone: json['phone'],
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role,
      'bio': bio,
      'phone': phone,
      'location': location,
    };
  }
}

class Customer extends User {
  String? address;

  Customer({
    required super.id,
    required super.username,
    required super.fullName,
    super.avatarUrl,
    super.bio,
    super.phone,
    required super.location,
    this.address,
  }) : super(role: 'customer');

  factory Customer.fromProfile(User profile, {String? address}) {
    return Customer(
      id: profile.id,
      username: profile.username,
      fullName: profile.fullName,
      avatarUrl: profile.avatarUrl,
      bio: profile.bio,
      phone: profile.phone,
      location: profile.location,
      address: address,
    );
  }

  @override
  String toString() {
    return 'Customer(id: $id, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, phone: $phone, location: $location, address: $address)';
  }
}

class Artisan extends User {
  double rating;

  Artisan({
    required super.id,
    required super.username,
    required super.fullName,
    super.avatarUrl,
    super.bio,
    super.phone,
    required super.location,
    this.rating = 0.0,
  }) : super(role: 'artisan');

  factory Artisan.fromProfile(User profile, {double rating = 0.0}) {
    return Artisan(
      id: profile.id,
      username: profile.username,
      fullName: profile.fullName,
      avatarUrl: profile.avatarUrl,
      bio: profile.bio,
      phone: profile.phone,
      location: profile.location,
      rating: rating,
    );
  }

  @override
  String toString() {
    return 'Artisan(id: $id, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, rating: $rating, bio: $bio, location: $location)';
  }
}
