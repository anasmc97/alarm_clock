import 'package:alarm_clock/feature/alarm_page/data/datasources/alarm_local_datasource.dart';
import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';
import 'package:alarm_clock/feature/alarm_page/domain/repositories/alarm_repository.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSources localDataSource;
  AlarmRepositoryImpl({required this.localDataSource});
  @override
  Future<void> saveAlarm(AlarmInfoModel? alarmInfoModel) {
    return localDataSource.saveAlarm(alarmInfoModel);
  }

  @override
  Future<List<AlarmInfoModel>> loadAlarms() {
    return localDataSource.loadAlarms();
  }

  @override
  Future<int?> deleteAlarm(int? id) {
    return localDataSource.deleteAlarm(id);
  }

  @override
  Future<int?> saveDurationRinging(String? duration, String? id) {
    return localDataSource.saveDurationRinging(duration, id);
  }
}
