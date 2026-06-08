/// Advisor Model
class Advisor {
  final String id;
  final String name;
  final String title;
  final String photoUrl;
  final double rating; // 0-5
  final int experienceYears;
  final int clientCount;
  final String bio;
  final String email;
  final String phone;

  const Advisor({
    required this.id,
    required this.name,
    required this.title,
    required this.photoUrl,
    required this.rating,
    required this.experienceYears,
    required this.clientCount,
    required this.bio,
    required this.email,
    required this.phone,
  });

  factory Advisor.fromJson(Map<String, dynamic> json) {
    return Advisor(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      photoUrl: json['photoUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      experienceYears: json['experienceYears'] as int,
      clientCount: json['clientCount'] as int,
      bio: json['bio'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'photoUrl': photoUrl,
      'rating': rating,
      'experienceYears': experienceYears,
      'clientCount': clientCount,
      'bio': bio,
      'email': email,
      'phone': phone,
    };
  }

  // Mock data for demo
  factory Advisor.mock() {
    return const Advisor(
      id: 'adv-001',
      name: 'Sarah Jenkins',
      title: 'Senior Retirement Advisor',
      photoUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      rating: 4.9,
      experienceYears: 12,
      clientCount: 240,
      bio:
          'Specializing in retirement planning with over a decade of experience helping individuals achieve their financial goals.',
      email: 'sarah.jenkins@advisors.com',
      phone: '+1 (555) 123-4567',
    );
  }
}
