import 'package:alarm_clock/feature/alarm_page/domain/entities/alarm_info_entity.dart';

class AlarmInfoModel extends AlarmInfo {
  AlarmInfoModel({
    required int? id,
    required String? title,
    required DateTime? alarmDateTime,
    required String? duration,
    required int? gradientColorIndex,
  }) : super(
            id: id,
            title: title,
            alarmDateTime: alarmDateTime,
            duration: duration,
            gradientColorIndex: gradientColorIndex);

  factory AlarmInfoModel.fromMap(Map<String, dynamic> json) => AlarmInfoModel(
        id: json["id"],
        title: json["title"],
        alarmDateTime: DateTime.parse(json["alarmDateTime"]),
        duration: json["duration"],
        gradientColorIndex: json["gradientColorIndex"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "alarmDateTime": alarmDateTime!.toIso8601String(),
        "duration": duration,
        "gradientColorIndex": gradientColorIndex,
      };
}
