import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String doctorId;
  final String userId;
  final String day;
  final TimeSlot timeSlot;
  final DateTime bookingDate;
  final String status;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.day,
    required this.timeSlot,
    required this.bookingDate,
    this.status = 'scheduled',
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      userId: json['userId'] as String,
      day: json['day'] as String,
      timeSlot: TimeSlot.fromJson(json['timeSlot'] as Map<String, dynamic>),
      bookingDate: (json['bookingDate'] as Timestamp).toDate(),
      status: json['status'] as String? ?? 'scheduled',
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
      'bookingDate': bookingDate,
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
  List<Object?> get props =>
      [id, doctorId, userId, day, timeSlot, bookingDate, status];
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
      id: json['id'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
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

class DaySchedule extends Equatable {
  final String day;
  final List<TimeSlot> availableHours;

  const DaySchedule({
    required this.day,
    required this.availableHours,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'] as String,
      availableHours: (json['availableHours'] as List<dynamic>)
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

  DaySchedule copyWith({
    String? day,
    List<TimeSlot>? availableHours,
  }) {
    return DaySchedule(
      day: day ?? this.day,
      availableHours: availableHours ?? this.availableHours,
    );
  }

  @override
  List<Object?> get props => [day, availableHours];
}
