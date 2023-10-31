import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:facebook/home/providers/auth_provider.dart';
import 'package:facebook/home/providers/list_provider.dart';
import 'package:facebook/home/task_list/task_widget.dart';
import 'package:facebook/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListTab extends StatefulWidget {
  const TaskListTab({super.key});

  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);

    listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    return Column(
      children: [
        CalendarTimeline(
          initialDate: listProvider.selectDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (date) {
            listProvider.changeSelectDate(date, authProvider.currentUser!.id!);
          },
          leftMargin: 20,
          monthColor: MyTheme.blackColor,
          dayColor: MyTheme.blackColor,
          activeDayColor: MyTheme.whiteColor,
          activeBackgroundDayColor: Theme.of(context).primaryColor,
          dotsColor: MyTheme.whiteColor,
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskWidget(
                task: listProvider.tasksList[index],
              );
            },
            itemCount: listProvider.tasksList.length,
          ),
        ),
      ],
    );
  }
}
