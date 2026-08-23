class User {
  String id;
  String username;
  String fullName;
  String? avatarUrl;
  String role;
  String? phone;
  String location;

  User({
    this.id = '',
    required this.username,
    required this.fullName,
    this.avatarUrl,
    required this.role,
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
  String? bio;
  List<String> skills;
  String? address;
  double rating;

  Artisan({
    required super.id,
    required super.username,
    required super.fullName,
    super.avatarUrl,
    super.phone,
    required super.location,
    this.bio,
    this.skills = const [],
    this.address,
    this.rating = 0.0,
  }) : super(role: 'artisan');

  factory Artisan.fromProfile(User profile, {
    String? bio,
    List<String> skills = const [],
    String? address,
    double rating = 0.0,
  }) {
    return Artisan(
      id: profile.id,
      username: profile.username,
      fullName: profile.fullName,
      avatarUrl: profile.avatarUrl,
      phone: profile.phone,
      location: profile.location,
      bio: bio,
      skills: skills,
      address: address,
      rating: rating,
    );
  }

  factory Artisan.fromJson(Map<String, dynamic> json) {
    final profile = User.fromJson(json);
    final artisanData = json['artisans'] != null ? 
        (json['artisans'] is List ? json['artisans'][0] : json['artisans']) : null;
    
    return Artisan.fromProfile(
      profile,
      bio: artisanData?['bio'],
      skills: artisanData?['skills'] != null ? List<String>.from(artisanData['skills']) : [],
      address: artisanData?['address'],
      rating: (artisanData?['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toArtisanJson() {
    return {
      'id': id,
      'bio': bio,
      'skills': skills,
      'address': address,
      'rating': rating,
    };
  }

  @override
  String toString() {
    return 'Artisan(id: $id, username: $username, fullName: $fullName, avatarUrl: $avatarUrl, rating: $rating, bio: $bio, skills: $skills, location: $location)';
  }
}
