import 'package:attendo_app/app_blocs/activity/bloc/activity_bloc.dart';
import 'package:attendo_app/app_blocs/group/bloc/group_bloc.dart';
import 'package:attendo_app/app_blocs/today_activity/bloc/today_activity_bloc.dart';
import 'package:attendo_app/screens/group/group_detail_screen.dart';
import 'package:attendo_app/widgets/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrUpdateActivityScreen extends StatefulWidget {
  final String groupId;
  final String? activityId;
  final Map<String, dynamic>? activityData;

  // Nếu activityId và activityData không null => Update mode
  // Nếu null => Create mode
  const CreateOrUpdateActivityScreen({
    required this.groupId,
    this.activityId,
    this.activityData,
  });

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<CreateOrUpdateActivityScreen> {
  late TextEditingController activityNameController;
  late TextEditingController activityDescriptionController;
  late String frequency;
  DateTime? selectedOnceDate;
  List<int>? selectedWeekDays;
  DateTime? selectedMonthlyDate;
  TimeOfDay? selectedTime;

  bool get isUpdateMode => widget.activityId != null;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and fields
    activityNameController = TextEditingController(
        text: isUpdateMode ? (widget.activityData?['name'] ?? '') : '');
    activityDescriptionController = TextEditingController(
        text: isUpdateMode ? (widget.activityData?['description'] ?? '') : '');
    frequency =
        isUpdateMode ? (widget.activityData?['frequency'] ?? 'Once') : 'Once';

    if (isUpdateMode) {
      //selectedOnceDate = widget.activityData?['onceDateOriginType'];
      //selectedWeekDays = widget.activityData?['weeklyDateOriginType'];
      //selectedMonthlyDate = widget.activityData?['monthlyDateOriginType'];
      final actTimeString = widget.activityData?['actTime'];
      if (actTimeString != null) {
        final timeParts = actTimeString.split(':');
        selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }
  }

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
        title: Text(isUpdateMode ? 'Update Activity' : 'Create Activity'),
      ),
      body: BlocListener<ActivityBloc, ActivityState>(
        listener: (context, state) {
          if (state is ActivityCreatedSuccess ||
              state is ActivityUpdatedSuccess) {
            context.read<TodayActivityBloc>().add(LoadTodayActivities());
            context.read<GroupBloc>().add(LoadGroups());
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Create activity successfully!'), behavior: SnackBarBehavior.floating,));

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GroupDetailScreen(groupId: widget.groupId)),
                (Route<dynamic> route) => route.isFirst);
          } else if (state is ActivityError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message), behavior: SnackBarBehavior.floating,));
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
                ),
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
                    if (isUpdateMode) {
                      BlocProvider.of<ActivityBloc>(context).add(
                        UpdateActivity(
                          groupId: widget.groupId,
                          activityId: widget.activityId!,
                          activityName: activityNameController.text,
                          frequency: frequency,
                          description:
                              activityDescriptionController.text.isNotEmpty
                                  ? activityDescriptionController.text
                                  : null,
                          onceDate:
                              frequency == 'Once' ? selectedOnceDate : null,
                          weeklyDate:
                              frequency == 'Weekly' ? selectedWeekDays : null,
                          monthlyDate: frequency == 'Monthly'
                              ? selectedMonthlyDate
                              : null,
                          actTime: selectedTime!,
                        ),
                      );
                    } else {
                      BlocProvider.of<ActivityBloc>(context).add(
                        CreateActivity(
                          groupId: widget.groupId,
                          activityName: activityNameController.text,
                          frequency: frequency,
                          description:
                              activityDescriptionController.text.isNotEmpty
                                  ? activityDescriptionController.text
                                  : null,
                          onceDate:
                              frequency == 'Once' ? selectedOnceDate : null,
                          weeklyDate:
                              frequency == 'Weekly' ? selectedWeekDays : null,
                          monthlyDate: frequency == 'Monthly'
                              ? selectedMonthlyDate
                              : null,
                          actTime: selectedTime!,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please complete all fields.'),behavior: SnackBarBehavior.floating,),
                    );
                  }
                },
                child:
                    Text(isUpdateMode ? 'Update Activity' : 'Create Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
