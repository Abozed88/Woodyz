class User {
  String id;
  String username;
  String fullName;
  String? avatarUrl;
  String role;
  String? phone;
  String location;
  String? address;
  String? bio;

  User({
    this.id = '',
    required this.username,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    this.phone,
    required this.location,
    this.address,
    this.bio,
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
      address: json['address'],
      bio: json['bio'],
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
      'bio': bio,
      // 'address' is excluded here because it might not exist in the profiles table for everyone
    };
  }

  /// Use this for inserting/updating the base profiles table
  Map<String, dynamic> toProfileJson() {
    return toJson();
  }
}

class Customer extends User {
  Customer({
    required super.id,
    required super.username,
    required super.fullName,
    super.avatarUrl,
    super.phone,
    required super.location,
    super.address,
  }) : super(role: 'customer');

  factory Customer.fromProfile(User profile, {String? address}) {
    return Customer(
      id: profile.id,
      username: profile.username,
      fullName: profile.fullName,
      avatarUrl: profile.avatarUrl,
      phone: profile.phone,
      location: profile.location,
      address: address ?? profile.address,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['address'] = address; // Include address for customers in profiles table
    return map;
  }
}

class Artisan extends User {
  List<String> skills;
  double rating;

  Artisan({
    required super.id,
    required super.username,
    required super.fullName,
    super.avatarUrl,
    super.phone,
    required super.location,
    super.bio,
    this.skills = const [],
    super.address,
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
      bio: bio ?? profile.bio,
      skills: skills,
      address: address ?? profile.address,
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
