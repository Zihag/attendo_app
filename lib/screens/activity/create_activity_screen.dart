import 'package:attendo_app/screens/group/group_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/widgets/date_time_picker.dart';

class CreateActivityScreen extends StatefulWidget {
  final String groupId;

  CreateActivityScreen({
    required this.groupId,
  });

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final activityNameController = TextEditingController();
  final activityDescriptionController = TextEditingController();
  String frequency = 'Once'; // Default frequency
  DateTime? selectedOnceDate;
  List<int>? selectedWeekDays;
  DateTime? selectedMonthlyDate;
  TimeOfDay? selectedTime;

  void _onDateTimeSelected(
      DateTime? date, List<int>? weekDays, TimeOfDay time) {
    setState(() {
      selectedTime = time;
      if (frequency == 'Once') {
        selectedOnceDate = date;
      } else if (frequency == 'Weekly') {
        selectedWeekDays = weekDays;
      } else if (frequency == 'Monthly') {
        selectedMonthlyDate = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Activity'),
      ),
      body: BlocListener<ActivityBloc, ActivityState>(
        listener: (context, state) {
          if (state is ActivityCreatedSuccess) {
            print('Create successful');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupDetailScreen(
                          groupId: widget.groupId,
                        )));
          } else if (state is ActivityError) {
            print('Create error');
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: activityNameController,
                decoration: InputDecoration(
                  labelText: 'Activity Name',
                ),
              ),
              TextField(
                  controller: activityDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  )),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: frequency,
                items: ['Once', 'Daily', 'Weekly', 'Monthly']
                    .map((freq) => DropdownMenuItem(
                          child: Text(freq),
                          value: freq,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    frequency = value!;
                    selectedOnceDate = null;
                    selectedWeekDays = null;
                    selectedMonthlyDate = null;
                    selectedTime = null;
                  });
                },
              ),
              SizedBox(height: 10),
              DateTimePickerWidget(
                frequency: frequency.toLowerCase(),
                onDateTimeSelected: _onDateTimeSelected,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (activityNameController.text.isNotEmpty &&
                      selectedTime != null) {
                    BlocProvider.of<ActivityBloc>(context).add(CreateActivity(
                        groupId: widget.groupId,
                        activityName: activityNameController.text,
                        frequency: frequency,
                        description:
                            activityDescriptionController.text.isNotEmpty
                                ? activityDescriptionController.text
                                : null,
                        onceDate: frequency == 'Once' ? selectedOnceDate : null,
                        weeklyDate:
                            frequency == 'Weekly' ? selectedWeekDays : null,
                        monthlyDate:
                            frequency == 'Monthly' ? selectedMonthlyDate : null,
                        actTime: selectedTime!));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please complete all fields.')),
                    );
                  }
                },
                child: Text('Create Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
