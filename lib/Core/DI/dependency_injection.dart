import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careplus/Features/Auth/Data/Repo/auth_repo.dart';
import 'package:careplus/Features/Auth/logic/auth_cubit.dart';
import 'package:careplus/Features/Top-Doctors/Data/Repo/doctor_repo.dart';
import 'package:careplus/Features/Top-Doctors/Logic/doctor_cubit.dart';

final getIt = GetIt.instance;

void setUpGetIt() {
  // Repositories
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(
        firebaseAuth: FirebaseAuth.instance,
      ));

  getIt.registerLazySingleton<DoctorRepo>(() => DoctorRepo(
        firestore: FirebaseFirestore.instance,
      ));

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(
        authRepo: getIt<AuthRepo>(),
      ));

  getIt.registerFactory<DoctorCubit>(() => DoctorCubit(
        doctorRepo: getIt<DoctorRepo>(),
      ));
}
