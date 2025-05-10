import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careplus/Features/Top-Doctors/Data/Model/doctor_model.dart';

class DoctorRepo {
  final FirebaseFirestore _firestore;

  DoctorRepo({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _doctorsCollection =>
      _firestore.collection('doctors');
  CollectionReference get _appointmentsCollection =>
      _firestore.collection('appointments');

  Stream<List<DoctorModel>> getAllDoctors() {
    return _doctorsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<DoctorModel?> getDoctorById(String doctorId) async {
    final docSnapshot = await _doctorsCollection.doc(doctorId).get();
    if (docSnapshot.exists) {
      return DoctorModel.fromFirestore(docSnapshot);
    }
    return null;
  }

  Stream<List<DoctorModel>> getTopRatedDoctors() {
    return _doctorsCollection
        .orderBy('rating', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DoctorModel.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<DoctorModel>> searchDoctors(String query) {
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

  Future<Appointment> bookAppointment({
    required String doctorId,
    required String userId,
    required String day,
    required TimeSlot timeSlot,
  }) async {
    final appointmentData = Appointment(
      id: '', // Will be set after document creation
      doctorId: doctorId,
      userId: userId,
      day: day,
      timeSlot: timeSlot,
      bookingDate: DateTime.now(),
    );

    final docRef = await _appointmentsCollection.add(appointmentData.toJson());

    final updatedAppointment = appointmentData.copyWith(id: docRef.id);
    await docRef.update({'id': docRef.id});

    await updateTimeSlotStatus(doctorId, day, timeSlot.id, true);

    return updatedAppointment;
  }

  Future<void> cancelAppointment(Appointment appointment) async {
    await _appointmentsCollection.doc(appointment.id).update({
      'status': 'cancelled',
    });

    await updateTimeSlotStatus(
      appointment.doctorId,
      appointment.day,
      appointment.timeSlot.id,
      false,
    );
  }

  Future<void> updateTimeSlotStatus(
    String doctorId,
    String day,
    String timeSlotId,
    bool isBooked,
  ) async {
    final doctorDoc = await _doctorsCollection.doc(doctorId).get();
    if (!doctorDoc.exists) return;

    final doctor = DoctorModel.fromFirestore(doctorDoc);

    final dayScheduleIndex =
        doctor.daySchedules.indexWhere((schedule) => schedule.day == day);
    if (dayScheduleIndex == -1) return;

    final timeSlotIndex = doctor.daySchedules[dayScheduleIndex].availableHours
        .indexWhere((slot) => slot.id == timeSlotId);
    if (timeSlotIndex == -1) return;

    final updatedDaySchedules = List<DaySchedule>.from(doctor.daySchedules);
    final updatedTimeSlots = List<TimeSlot>.from(
        updatedDaySchedules[dayScheduleIndex].availableHours);

    updatedTimeSlots[timeSlotIndex] =
        updatedTimeSlots[timeSlotIndex].copyWith(isBooked: isBooked);

    updatedDaySchedules[dayScheduleIndex] = DaySchedule(
      day: updatedDaySchedules[dayScheduleIndex].day,
      availableHours: updatedTimeSlots,
    );

    await _doctorsCollection.doc(doctorId).update({
      'daySchedules':
          updatedDaySchedules.map((schedule) => schedule.toJson()).toList(),
    });
  }

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
