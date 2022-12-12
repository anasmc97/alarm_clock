import 'package:alarm_clock/core/utils/shared_value.dart';
import 'package:alarm_clock/feature/alarm_page/presentation/blocs/alarm_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmBarChartPage extends StatefulWidget {
  const AlarmBarChartPage({super.key});

  @override
  State<StatefulWidget> createState() => AlarmBarChartPageState();
}

class AlarmBarChartPageState extends State<AlarmBarChartPage> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData>? showingBarGroups = [];

  int touchedGroupIndex = -1;

  @override
  void initState() {
    context.read<AlarmBloc>().add(LoadAlarmsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlarmBloc, AlarmState>(
      listener: (context, state) {
        if (state.alarmStatus == AlarmStatus.successLoadAlarm) {
          for (int i = 0; i < state.currentAlarms!.length; i++) {
            rawBarGroups.add(
              makeGroupData(
                i,
                double.parse(state.currentAlarms![i].duration ?? '0'),
              ),
            );
          }
          showingBarGroups = rawBarGroups;
        }
      },
      child: BlocBuilder<AlarmBloc, AlarmState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.seconds.toString() ?? '0'),
            ),
            body: AspectRatio(
              aspectRatio: 1,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: CustomColors.pageBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 38,
                      ),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            maxY: 10,
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: CustomColors.dividerColor,
                                getTooltipItem: (a, b, c, d) => null,
                              ),
                              touchCallback: (FlTouchEvent event, response) {
                                if (response == null || response.spot == null) {
                                  setState(() {
                                    touchedGroupIndex = -1;
                                    showingBarGroups = List.of(rawBarGroups);
                                  });
                                  return;
                                }

                                touchedGroupIndex =
                                    response.spot!.touchedBarGroupIndex;

                                setState(() {
                                  if (!event.isInterestedForInteractions) {
                                    touchedGroupIndex = -1;
                                    showingBarGroups = List.of(rawBarGroups);
                                    return;
                                  }
                                  showingBarGroups = List.of(rawBarGroups);
                                  if (touchedGroupIndex != -1) {
                                    var sum = 0.0;
                                    for (final rod
                                        in showingBarGroups![touchedGroupIndex]
                                            .barRods) {
                                      sum += rod.toY;
                                    }
                                    final avg = sum /
                                        showingBarGroups![touchedGroupIndex]
                                            .barRods
                                            .length;

                                    showingBarGroups![touchedGroupIndex] =
                                        showingBarGroups![touchedGroupIndex]
                                            .copyWith(
                                      barRods:
                                          showingBarGroups![touchedGroupIndex]
                                              .barRods
                                              .map((rod) {
                                        return rod.copyWith(toY: avg);
                                      }).toList(),
                                    );
                                  }
                                });
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitles,
                                  reservedSize: 42,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  interval: 1,
                                  getTitlesWidget: leftTitles,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: showingBarGroups,
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: CustomColors.dividerColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = value.toInt().toString();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = BlocBuilder<AlarmBloc, AlarmState>(
      builder: (context, state) {
        return Text(
          '${state.currentAlarms![value.toInt()].alarmDateTime!.hour} : ${state.currentAlarms![value.toInt()].alarmDateTime!.minute}',
          style: TextStyle(
            color: CustomColors.dividerColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        );
      },
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
