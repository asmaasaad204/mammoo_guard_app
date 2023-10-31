import 'package:facebook/dialog_utils.dart';
import 'package:facebook/firebase_utils.dart';
import 'package:facebook/home/providers/list_provider.dart';
import 'package:facebook/models/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Add new Task',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (text) {
                      title = text;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'please enter task title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Task Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (text) {
                      description = text;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'please enter task description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Task Description',
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select Date',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showCalender();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Text(
                    'Add',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {});
    }
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      /// add task to firebase
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
      );

      DialogUtils.showLoading(context, 'Loading...');
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      FirebaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id!)
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Task added successfully',
            posActionName: 'ok', posAction: () {
          Navigator.pop(context);
          // Navigator.pop(context);
        });
      }).timeout(const Duration(milliseconds: 500), onTimeout: () {
        print('ToDo added successfully');
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
        Navigator.pop(context);
      });
    }
  }
}
