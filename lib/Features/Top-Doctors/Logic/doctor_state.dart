part of 'doctor_cubit.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object> get props => [];
}

// Initial state
class DoctorInitial extends DoctorState {}

// Loading states
class DoctorLoading extends DoctorState {}

class AppointmentBookingLoading extends DoctorState {}

class AppointmentCancellationLoading extends DoctorState {}

class AppointmentsLoading extends DoctorState {}

// Success states
class DoctorsLoaded extends DoctorState {
  final List<DoctorModel> doctors;

  const DoctorsLoaded(this.doctors);

  @override
  List<Object> get props => [doctors];
}

class DoctorDetailLoaded extends DoctorState {
  final DoctorModel doctor;

  const DoctorDetailLoaded(this.doctor);

  @override
  List<Object> get props => [doctor];
}

class AppointmentBookingSuccess extends DoctorState {
  final Appointment appointment;

  const AppointmentBookingSuccess(this.appointment);

  @override
  List<Object> get props => [appointment];
}

class AppointmentCancellationSuccess extends DoctorState {}

class UserAppointmentsLoaded extends DoctorState {
  final List<Appointment> appointments;

  const UserAppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

class DoctorAppointmentsLoaded extends DoctorState {
  final List<Appointment> appointments;

  const DoctorAppointmentsLoaded(this.appointments);

  @override
  List<Object> get props => [appointments];
}

// Error states
class DoctorError extends DoctorState {
  final String message;

  const DoctorError(this.message);

  @override
  List<Object> get props => [message];
}

class AppointmentBookingError extends DoctorState {
  final String message;

  const AppointmentBookingError(this.message);

  @override
  List<Object> get props => [message];
}

class AppointmentCancellationError extends DoctorState {
  final String message;

  const AppointmentCancellationError(this.message);

  @override
  List<Object> get props => [message];
}

class AppointmentsError extends DoctorState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object> get props => [message];
}
