import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carepulse/Features/Top-Doctors/Data/Model/doctor_model.dart';

class DoctorRepo {
  final FirebaseFirestore _firestore;

  DoctorRepo({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _doctorsCollection =>
      _firestore.collection('doctors');
  CollectionReference get _appointmentsCollection =>
      _firestore.collection('appointments');

  // Get all doctors
  Stream<List<DoctorModel>> getAllDoctors() {
    return _doctorsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get doctor by id
  Future<DoctorModel?> getDoctorById(String doctorId) async {
    final docSnapshot = await _doctorsCollection.doc(doctorId).get();
    if (docSnapshot.exists) {
      return DoctorModel.fromFirestore(docSnapshot);
    }
    return null;
  }

  // Get top rated doctors
  Stream<List<DoctorModel>> getTopRatedDoctors({int limit = 10}) {
    return _doctorsCollection
        .orderBy('rating', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    });
  }

  // Search doctors by name or speciality
  Stream<List<DoctorModel>> searchDoctors(String query) {
    // Convert query to lowercase for case-insensitive search
    final lowerCaseQuery = query.toLowerCase();

    return _doctorsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .where((doctor) {
        final nameMatch = doctor.name.toLowerCase().contains(lowerCaseQuery);
        final specialityMatch =
            doctor.speciality.toLowerCase().contains(lowerCaseQuery);
        return nameMatch || specialityMatch;
      }).toList();
    });
  }

  // Book an appointment
  Future<Appointment> bookAppointment({
    required String doctorId,
    required String userId,
    required String day,
    required TimeSlot timeSlot,
  }) async {
    // Create a new appointment document
    final appointmentData = Appointment(
      id: '', // Will be set after document creation
      doctorId: doctorId,
      userId: userId,
      day: day,
      timeSlot: timeSlot,
      bookingDate: DateTime.now(),
    );

    // Add to Firestore
    final docRef = await _appointmentsCollection.add(appointmentData.toJson());

    // Update the appointment with the generated ID
    final updatedAppointment = appointmentData.copyWith(id: docRef.id);
    await docRef.update({'id': docRef.id});

    // Update the doctor's schedule to mark the time slot as booked
    await updateTimeSlotStatus(doctorId, day, timeSlot.id, true);

    return updatedAppointment;
  }

  // Cancel an appointment
  Future<void> cancelAppointment(Appointment appointment) async {
    // Update appointment status
    await _appointmentsCollection.doc(appointment.id).update({
      'status': 'cancelled',
    });

    // Update the doctor's schedule to mark the time slot as available again
    await updateTimeSlotStatus(
      appointment.doctorId,
      appointment.day,
      appointment.timeSlot.id,
      false,
    );
  }

  // Update time slot booking status
  Future<void> updateTimeSlotStatus(
    String doctorId,
    String day,
    String timeSlotId,
    bool isBooked,
  ) async {
    // Get the doctor document
    final doctorDoc = await _doctorsCollection.doc(doctorId).get();
    if (!doctorDoc.exists) return;

    final doctor = DoctorModel.fromFirestore(doctorDoc);

    // Find the day schedule
    final dayScheduleIndex =
        doctor.daySchedules.indexWhere((schedule) => schedule.day == day);
    if (dayScheduleIndex == -1) return;

    // Find the time slot
    final timeSlotIndex = doctor.daySchedules[dayScheduleIndex].availableHours
        .indexWhere((slot) => slot.id == timeSlotId);
    if (timeSlotIndex == -1) return;

    // Update the doctor document with the new schedule
    final updatedDaySchedules = List<DaySchedule>.from(doctor.daySchedules);
    final updatedTimeSlots = List<TimeSlot>.from(
        updatedDaySchedules[dayScheduleIndex].availableHours);

    // Update the specific time slot
    updatedTimeSlots[timeSlotIndex] =
        updatedTimeSlots[timeSlotIndex].copyWith(isBooked: isBooked);

    // Update the day schedule with the updated time slots
    updatedDaySchedules[dayScheduleIndex] = DaySchedule(
      day: updatedDaySchedules[dayScheduleIndex].day,
      availableHours: updatedTimeSlots,
    );

    // Update the doctor document
    await _doctorsCollection.doc(doctorId).update({
      'daySchedules':
          updatedDaySchedules.map((schedule) => schedule.toJson()).toList(),
    });
  }

  // Get user appointments
  Stream<List<Appointment>> getUserAppointments(String userId) {
    return _appointmentsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromFirestore(doc))
          .toList();
    });
  }

  // Get doctor appointments
  Stream<List<Appointment>> getDoctorAppointments(String doctorId) {
    return _appointmentsCollection
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Appointment.fromFirestore(doc))
          .toList();
    });
  }
}
