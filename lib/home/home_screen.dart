import 'package:facebook/auth/login/login_screen.dart';
import 'package:facebook/home/providers/auth_provider.dart';
import 'package:facebook/home/providers/list_provider.dart';
import 'package:facebook/home/task_list/add_task_bottom_sheet.dart';
import 'package:facebook/home/task_list/task_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TO DO List  ${authProvider.currentUser!.name}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                listProvider.tasksList = [];
                authProvider.currentUser = null;
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context)!.task_list,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  List<Widget> tabs = [
    const TaskListTab(),
  ];

  void showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const AddTaskBottomSheet(),
    );
  }
}
