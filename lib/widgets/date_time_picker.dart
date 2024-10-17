import 'package:flutter/material.dart';

class DateTimePickerWidget extends StatefulWidget {
  final Function(DateTime, List<int>?) onDateTimeSelected; // Hàm callback trả về ngày và danh sách ngày tuần (nếu chọn weekly)
  final String frequency; // Chọn loại tần suất (once, daily, weekly, monthly)

  DateTimePickerWidget({required this.onDateTimeSelected, required this.frequency});

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime? selectedDateTime;
  TimeOfDay? selectedTime;
  List<int> selectedWeekDays = []; // Lưu trữ các ngày trong tuần đã chọn cho weekly

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDateTime = pickedDate;
      });
    }
  }

  // Hàm chọn giờ
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        if (selectedDateTime != null) {
          selectedDateTime = DateTime(
            selectedDateTime!.year,
            selectedDateTime!.month,
            selectedDateTime!.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      });
    }
  }

  // Hàm chọn nhiều ngày trong tuần cho weekly
  Widget _buildWeekDaySelector() {
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Wrap(
      children: List.generate(weekDays.length, (index) {
        return ChoiceChip(
          label: Text(weekDays[index]),
          selected: selectedWeekDays.contains(index + 1),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedWeekDays.add(index + 1);
              } else {
                selectedWeekDays.remove(index + 1);
              }
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.frequency == 'once' || widget.frequency == 'monthly')
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              selectedDateTime == null
                  ? 'Select Date'
                  : '${selectedDateTime!.toLocal()}'.split(' ')[0],
            ),
          ),
        if (widget.frequency == 'weekly') _buildWeekDaySelector(),
        ElevatedButton(
          onPressed: () => _selectTime(context),
          child: Text(selectedTime == null ? 'Select Time' : selectedTime!.format(context)),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.frequency == 'weekly' && selectedWeekDays.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please select at least one day of the week')),
              );
              return;
            }
            // Gọi hàm callback với kết quả chọn
            widget.onDateTimeSelected(
              selectedDateTime ?? DateTime.now(),
              widget.frequency == 'weekly' ? selectedWeekDays : null,
            );
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
