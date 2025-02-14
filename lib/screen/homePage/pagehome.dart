import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PageHome extends StatefulWidget {
  final String temp; // 새로 추가된 필드
  const PageHome({Key? key, required this.temp}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  List<Event> currentEvents = [];


  late final DateTime firstDay = DateTime(2023, 1, 1);

  Map<DateTime, List<Event>> events = {
    DateTime.utc(2024, 5, 15): [
      Event('title', "16:00", "18:00"),
      Event('title2', "18:00", "20:00"),
    ],
    DateTime.utc(2024, 5, 16): [
      Event('title3', "16:00", "18:00"),
    ],
  };
  List<Event> _getEventsForDay(DateTime day) {
    setState(() {
      currentEvents = events[day] ?? [];
    });
    print(currentEvents);
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    int difference = DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1;

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 2000,
        child: Padding(
          padding: EdgeInsets.all(20), // 디자인 변경에 따른 수정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, // 테스트
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text("뽀삐와 함께한지 D+${difference}일"),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Calendar(
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                    _getEventsForDay(this.selectedDay);
                  },
                  selectedDayPredicate: (DateTime day) {
                    return isSameDay(selectedDay, day);
                  },
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xCC606060),
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                          blurStyle: BlurStyle.outer,
                        )
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text("오늘의 일정"),
                        Column(
                          children: currentEvents
                              .map((e) => MainEvent(
                                    startTime: e.start,
                                    endTime: e.end,
                                    title: e.title,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 32.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text("개는 왜 짖을까요??"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final bool Function(DateTime day) selectedDayPredicate;

  const Calendar({
    required this.onDaySelected,
    required this.selectedDayPredicate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16), // 바꾸니까 현재 날짜 포커스 풀림 (?
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarFormat: CalendarFormat.week,
        onDaySelected: onDaySelected,
        selectedDayPredicate: selectedDayPredicate);
  }
}

class Event {
  final String title;
  final String start;
  final String end;

  Event(this.title, this.start, this.end);
}

class MainEvent extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String title;

  const MainEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('$startTime - $endTime'),
    );
  }
}
