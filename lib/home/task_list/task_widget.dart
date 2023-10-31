import 'package:facebook/firebase_utils.dart';
import 'package:facebook/home/providers/list_provider.dart';
import 'package:facebook/home/task_list/edit_task.dart';
import 'package:facebook/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../providers/auth_provider.dart';

class TaskWidget extends StatefulWidget {
  Task task;

  TaskWidget({super.key, required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    var uId = authProvider.currentUser!.id!;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EditTask.routeName,
            arguments: widget.task);
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  /// delete task
                  FirebaseUtils.deleteTaskFromFireStore(widget.task, uId)
                      .timeout(const Duration(milliseconds: 500),
                          onTimeout: () {
                    print('deleted successfully');
                    listProvider.getAllTasksFromFireStore(uId);
                  });
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                backgroundColor: MyTheme.redColor,
                foregroundColor: MyTheme.whiteColor,
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.delete,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: MyTheme.whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: widget.task.isDone!
                      ? MyTheme.greenColor
                      : Theme.of(context).primaryColor,
                  height: 80,
                  width: 4,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.task.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: widget.task.isDone!
                                  ? MyTheme.greenColor
                                  : Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.task.description ?? '',
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                  ],
                )),
                InkWell(
                  onTap: () {
                    widget.task.isDone = !widget.task.isDone!;
                    FirebaseUtils.editIsDone(widget.task, uId);
                    setState(() {});
                  },
                  child: widget.task.isDone!
                      ? Text(
                          'Done!',
                          style: TextStyle(
                            color: MyTheme.greenColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 30,
                            color: MyTheme.whiteColor,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
