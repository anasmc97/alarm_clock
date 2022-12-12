import 'package:alarm_clock/feature/alarm_page/data/datasources/alarm_local_datasource.dart';
import 'package:alarm_clock/feature/alarm_page/data/repositories/alarm_repository_impl.dart';
import 'package:alarm_clock/feature/alarm_page/domain/repositories/alarm_repository.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/delete_alarm_usecase.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/load_alarms_usecase.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/save_alarm_usecase.dart';
import 'package:alarm_clock/feature/alarm_page/domain/usecases/save_duration_ringing_usecase.dart';
import 'package:alarm_clock/feature/alarm_page/presentation/blocs/alarm_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Login
  // Bloc
  sl.registerFactory(
    () => AlarmBloc(
      saveAlarm: sl(),
      loadAlarms: sl(),
      deleteAlarm: sl(),
      saveDurationRinging: sl(),
      notifications: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SaveAlarmUsecase(sl()));
  sl.registerLazySingleton(() => LoadAlarmsUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAlarmUsecase(sl()));
  sl.registerLazySingleton(() => SaveDurationRingingUsecase(sl()));

  // Repository
  sl.registerLazySingleton<AlarmRepository>(
    () => AlarmRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AlarmLocalDataSources>(
    () => AlarmLocalDataSourcesImpl(),
  );

  //eksternal
  final notifications = FlutterLocalNotificationsPlugin();
  sl.registerLazySingleton(() => notifications);
}
