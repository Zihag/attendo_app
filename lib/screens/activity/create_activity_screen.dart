import 'package:attendo_app/screens/group/group_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/widgets/date_time_picker.dart';

class CreateActivityScreen extends StatefulWidget {
  final String groupId;

  CreateActivityScreen({required this.groupId});

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final activityNameController = TextEditingController();
  final activityDescriptionController = TextEditingController();
  String frequency = 'Once'; // Default frequency
  DateTime? selectedDateTime;
  List<int>? selectedWeekDays;

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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GroupDetailScreen(groupId: widget.groupId)));
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
                decoration: InputDecoration(labelText: 'Activity Name'),
              ),
              TextField(
                controller: activityDescriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
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
                  });
                },
              ),
              SizedBox(height: 10),
              DateTimePickerWidget(
                frequency: frequency.toLowerCase(),
                onDateTimeSelected: (DateTime dateTime, List<int>? weekDays) {
                  setState(() {
                    selectedDateTime = dateTime;
                    selectedWeekDays = weekDays;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (activityNameController.text.isNotEmpty &&
                      selectedDateTime != null) {
                    BlocProvider.of<ActivityBloc>(context).add(
                      CreateActivity(
                        groupId: widget.groupId,
                        activityName: activityNameController.text,
                        description: activityDescriptionController.text,
                        startTime: selectedDateTime!,
                        frequency: frequency,
                        weekDays: selectedWeekDays,
                      ),
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