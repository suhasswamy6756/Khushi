import 'package:flutter/material.dart';
import 'package:kushi_3/pages/Fragments/NotifiactionFragment/allfragment.dart';
import 'package:kushi_3/pages/Fragments/NotifiactionFragment/eventsfragment.dart';
import 'package:kushi_3/pages/Fragments/NotifiactionFragment/newfragment.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}
int _labelStart = 1;
class _NotificationPageState extends State<NotificationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Center(child: Text('Notifications')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: ToggleSwitch(
              minWidth: 150.0,
              initialLabelIndex: _labelStart, // Set initial index
              cornerRadius: 30.0,
              radiusStyle: true,
              activeBgColor: const [Colors.white],
              customTextStyles: const [
                TextStyle(color: Colors.black), // Style for "Events" label
                TextStyle(color: Colors.black), // Style for "New" label
                TextStyle(color: Colors.black), // Style for "All" label
              ],
              borderColor: const [Colors.grey],
              inactiveBgColor: Colors.white54,
              inactiveFgColor: Colors.grey,
              totalSwitches: 3,
              labels: const ["Events", "New", "All"],
              onToggle: (index) {
                if(index != null) {
                  setState(() {
                    _labelStart = index;

                  });
                }
              },
            ),
          ),
        ),
      ),
      body: _selectedFragment(), // Call a function to display the selected fragment
    );
  }
  Widget _selectedFragment() {
    switch (_labelStart) {
      case 0:
        return const EventsFragment();
      case 1:
        return const NewFragment();
      case 2:
        return const AllFragment();
      default:
        return Container();
    }
  }
}