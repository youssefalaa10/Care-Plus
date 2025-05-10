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
    emit(DoctorLoading());
    try {
      _doctorRepo.getAllDoctors().listen(
        (doctors) {
          emit(DoctorsLoaded(doctors));
        },
        onError: (error) {
          emit(DoctorError(error.toString()));
        },
      );
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  // Load top rated doctors
  void loadTopRatedDoctors() {
    emit(DoctorLoading());
    try {
      _doctorRepo.getTopRatedDoctors().listen(
        (doctors) {
          emit(DoctorsLoaded(doctors));
        },
        onError: (error) {
          emit(DoctorError(error.toString()));
        },
        onDone: () {
          if (state is DoctorLoading) {
            emit(const DoctorsLoaded([]));
          }
        },
      );
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  // Search doctors
  void searchDoctors(String query) {
    emit(DoctorLoading());
    try {
      if (query.isEmpty) {
        loadDoctors();
        return;
      }

      _doctorRepo.searchDoctors(query).listen(
        (doctors) {
          emit(DoctorsLoaded(doctors));
        },
        onError: (error) {
          emit(DoctorError(error.toString()));
        },
      );
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  // Get doctor by ID
  Future<void> getDoctorById(String doctorId) async {
    emit(DoctorLoading());
    try {
      final doctor = await _doctorRepo.getDoctorById(doctorId);
      if (doctor != null) {
        emit(DoctorDetailLoaded(doctor));
      } else {
        emit(const DoctorError('Doctor not found'));
      }
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  // Book appointment
  Future<void> bookAppointment({
    required String doctorId,
    required String userId,
    required String day,
    required TimeSlot timeSlot,
  }) async {
    emit(AppointmentBookingLoading());
    try {
      final appointment = await _doctorRepo.bookAppointment(
        doctorId: doctorId,
        userId: userId,
        day: day,
        timeSlot: timeSlot,
      );
      emit(AppointmentBookingSuccess(appointment));
    } catch (e) {
      emit(AppointmentBookingError(e.toString()));
    }
  }

  // Cancel appointment
  Future<void> cancelAppointment(Appointment appointment) async {
    emit(AppointmentCancellationLoading());
    try {
      await _doctorRepo.cancelAppointment(appointment);
      emit(AppointmentCancellationSuccess());
    } catch (e) {
      emit(AppointmentCancellationError(e.toString()));
    }
  }

  // Load user appointments
  void loadUserAppointments(String userId) {
    emit(AppointmentsLoading());
    try {
      _doctorRepo.getUserAppointments(userId).listen(
        (appointments) {
          emit(UserAppointmentsLoaded(appointments));
        },
        onError: (error) {
          emit(AppointmentsError(error.toString()));
        },
      );
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }

  // Load doctor appointments
  void loadDoctorAppointments(String doctorId) {
    emit(AppointmentsLoading());
    try {
      _doctorRepo.getDoctorAppointments(doctorId).listen(
        (appointments) {
          emit(DoctorAppointmentsLoaded(appointments));
        },
        onError: (error) {
          emit(AppointmentsError(error.toString()));
        },
      );
    } catch (e) {
      emit(AppointmentsError(e.toString()));
    }
  }
}
