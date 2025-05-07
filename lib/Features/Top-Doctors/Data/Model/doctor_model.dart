import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DoctorModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String location;
  final String speciality;
  final bool isOnline;
  final int numOfPatients;
  final String about;
  final int numOfExperience;
  final int numOfReview;
  final List<DaySchedule> daySchedules;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.speciality,
    this.isOnline = false,
    required this.numOfPatients,
    required this.about,
    required this.numOfExperience,
    required this.numOfReview,
    required this.daySchedules,
  });

  static const String defaultImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsWufOYfRXMzgZXJn0WjLm-7us-UifmvjMdrjdjVjhaUUjRLb7xg&s=10&ec=72940545';

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String? ?? defaultImageUrl,
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
      speciality: json['speciality'] as String,
      isOnline: json['isOnline'] as bool? ?? false,
      numOfPatients: json['numOfPatients'] as int,
      about: json['about'] as String,
      numOfExperience: json['numOfExperience'] as int,
      numOfReview: json['numOfReview'] as int,
      daySchedules: (json['daySchedules'] as List<dynamic>)
          .map((e) => DaySchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      // Handle null data case
      return DoctorModel(
        id: doc.id,
        name: 'Unknown',
        imageUrl: defaultImageUrl,
        rating: 0.0,
        location: 'Unknown',
        speciality: 'General',
        numOfPatients: 0,
        about: 'No information available',
        numOfExperience: 0,
        numOfReview: 0,
        daySchedules: [],
      );
    }

    // Handle potential null values in the data
    return DoctorModel(
      id: doc.id,
      name: data['name'] as String? ?? 'Unknown',
      imageUrl: data['imageUrl'] as String? ?? defaultImageUrl,
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : 0.0,
      location: data['location'] as String? ?? 'Unknown',
      speciality: data['speciality'] as String? ?? 'General',
      isOnline: data['isOnline'] as bool? ?? false,
      numOfPatients: data['numOfPatients'] as int? ?? 0,
      about: data['about'] as String? ?? 'No information available',
      numOfExperience: data['numOfExperience'] as int? ?? 0,
      numOfReview: data['numOfReview'] as int? ?? 0,
      daySchedules: data['daySchedules'] != null
          ? (data['daySchedules'] as List<dynamic>)
              .map((e) => DaySchedule.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'location': location,
      'speciality': speciality,
      'isOnline': isOnline,
      'numOfPatients': numOfPatients,
      'about': about,
      'numOfExperience': numOfExperience,
      'numOfReview': numOfReview,
      'daySchedules': daySchedules.map((e) => e.toJson()).toList(),
    };
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? rating,
    String? location,
    String? speciality,
    bool? isOnline,
    int? numOfPatients,
    String? about,
    int? numOfExperience,
    int? numOfReview,
    List<DaySchedule>? daySchedules,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      speciality: speciality ?? this.speciality,
      isOnline: isOnline ?? this.isOnline,
      numOfPatients: numOfPatients ?? this.numOfPatients,
      about: about ?? this.about,
      numOfExperience: numOfExperience ?? this.numOfExperience,
      numOfReview: numOfReview ?? this.numOfReview,
      daySchedules: daySchedules ?? this.daySchedules,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        rating,
        location,
        speciality,
        isOnline,
        numOfPatients,
        about,
        numOfExperience,
        numOfReview,
        daySchedules,
      ];
}

class DaySchedule extends Equatable {
  final String day;
  final List<TimeSlot> availableHours;

  const DaySchedule({
    required this.day,
    required this.availableHours,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'] as String? ?? 'Unknown',
      availableHours: (json['availableHours'] as List<dynamic>? ?? [])
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'availableHours': availableHours.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [day, availableHours];
}

class TimeSlot extends Equatable {
  final String id;
  final String startTime;
  final String endTime;
  final bool isBooked;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      isBooked: json['isBooked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'isBooked': isBooked,
    };
  }

  TimeSlot copyWith({
    String? id,
    String? startTime,
    String? endTime,
    bool? isBooked,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  @override
  List<Object?> get props => [id, startTime, endTime, isBooked];
}

class Appointment extends Equatable {
  final String id;
  final String doctorId;
  final String userId;
  final String day;
  final TimeSlot timeSlot;
  final DateTime bookingDate;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.day,
    required this.timeSlot,
    required this.bookingDate,
    this.status = 'pending',
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      userId: json['userId'] as String,
      day: json['day'] as String,
      timeSlot: TimeSlot.fromJson(json['timeSlot'] as Map<String, dynamic>),
      bookingDate: (json['bookingDate'] as Timestamp).toDate(),
      status: json['status'] as String,
    );
  }

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userId': userId,
      'day': day,
      'timeSlot': timeSlot.toJson(),
      'bookingDate': Timestamp.fromDate(bookingDate),
      'status': status,
    };
  }

  Appointment copyWith({
    String? id,
    String? doctorId,
    String? userId,
    String? day,
    TimeSlot? timeSlot,
    DateTime? bookingDate,
    String? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      userId: userId ?? this.userId,
      day: day ?? this.day,
      timeSlot: timeSlot ?? this.timeSlot,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        doctorId,
        userId,
        day,
        timeSlot,
        bookingDate,
        status,
      ];
}
