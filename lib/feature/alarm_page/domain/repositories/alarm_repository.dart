import 'package:alarm_clock/feature/alarm_page/data/models/alarm_info_model.dart';

abstract class AlarmRepository {
  Future<void> saveAlarm(AlarmInfoModel? alarmInfoModel);
  Future<List<AlarmInfoModel>> loadAlarms();
  Future<int?> deleteAlarm(int? id);
  Future<int?> saveDurationRinging(String? duration, String? id);
}
