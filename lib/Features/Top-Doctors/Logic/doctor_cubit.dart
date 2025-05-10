import 'package:equatable/equatable.dart';
import 'package:careplus/Features/Top-Doctors/Data/Model/doctor_model.dart';
import 'package:careplus/Features/Top-Doctors/Data/Repo/doctor_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final DoctorRepo _doctorRepo;

  DoctorCubit({required DoctorRepo doctorRepo})
      : _doctorRepo = doctorRepo,
        super(DoctorInitial());

  // Load all doctors
  void loadDoctors() {
    if (!isClosed) emit(DoctorLoading());
    try {
      _doctorRepo.getAllDoctors().listen(
        (doctors) {
          if (!isClosed) emit(DoctorsLoaded(doctors));
        },
        onError: (error) {
          if (!isClosed) emit(DoctorError(error.toString()));
        },
      );
    } catch (e) {
      if (!isClosed) emit(DoctorError(e.toString()));
    }
  }

  // Load top rated doctors
  void loadTopRatedDoctors() {
    if (!isClosed) emit(DoctorLoading());
    try {
      _doctorRepo.getTopRatedDoctors().listen(
        (doctors) {
          if (!isClosed) emit(DoctorsLoaded(doctors));
        },
        onError: (error) {
          if (!isClosed) emit(DoctorError(error.toString()));
        },
        onDone: () {
          if (state is DoctorLoading) {
            if (!isClosed) emit(const DoctorsLoaded([]));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(DoctorError(e.toString()));
    }
  }

  // Search doctors
  void searchDoctors(String query) {
    if (!isClosed) emit(DoctorLoading());
    try {
      if (query.isEmpty) {
        loadDoctors();
        return;
      }

      _doctorRepo.searchDoctors(query).listen(
        (doctors) {
          if (!isClosed) emit(DoctorsLoaded(doctors));
        },
        onError: (error) {
          if (!isClosed) emit(DoctorError(error.toString()));
        },
      );
    } catch (e) {
      if (!isClosed) emit(DoctorError(e.toString()));
    }
  }

  // Get doctor by ID
  Future<void> getDoctorById(String doctorId) async {
    if (!isClosed) emit(DoctorLoading());
    try {
      final doctor = await _doctorRepo.getDoctorById(doctorId);
      if (doctor != null) {
        if (!isClosed) emit(DoctorDetailLoaded(doctor));
      } else {
        if (!isClosed) emit(const DoctorError('Doctor not found'));
      }
    } catch (e) {
      if (!isClosed) emit(DoctorError(e.toString()));
    }
  }

  // Book appointment
  Future<void> bookAppointment({
    required String doctorId,
    required String userId,
    required String day,
    required TimeSlot timeSlot,
  }) async {
    if (!isClosed) emit(AppointmentBookingLoading());
    try {
      final appointment = await _doctorRepo.bookAppointment(
        doctorId: doctorId,
        userId: userId,
        day: day,
        timeSlot: timeSlot,
      );
      if (!isClosed) emit(AppointmentBookingSuccess(appointment));
    } catch (e) {
      if (!isClosed) emit(AppointmentBookingError(e.toString()));
    }
  }

  // Cancel appointment
  Future<void> cancelAppointment(Appointment appointment) async {
    if (!isClosed) emit(AppointmentCancellationLoading());
    try {
      await _doctorRepo.cancelAppointment(appointment);
      if (!isClosed) emit(AppointmentCancellationSuccess());
    } catch (e) {
      if (!isClosed) emit(AppointmentCancellationError(e.toString()));
    }
  }

  // Load user appointments
  void loadUserAppointments(String userId) {
    if (!isClosed) emit(AppointmentsLoading());
    try {
      _doctorRepo.getUserAppointments(userId).listen(
        (appointments) {
          if (!isClosed) emit(UserAppointmentsLoaded(appointments));
        },
        onError: (error) {
          if (!isClosed) emit(AppointmentsError(error.toString()));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AppointmentsError(e.toString()));
    }
  }

  // Load doctor appointments
  void loadDoctorAppointments(String doctorId) {
    if (!isClosed) emit(AppointmentsLoading());
    try {
      _doctorRepo.getDoctorAppointments(doctorId).listen(
        (appointments) {
          if (!isClosed) emit(DoctorAppointmentsLoaded(appointments));
        },
        onError: (error) {
          if (!isClosed) emit(AppointmentsError(error.toString()));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AppointmentsError(e.toString()));
    }
  }
}
