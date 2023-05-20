import 'package:flutter_booktickets_app/controllers/task_controller.dart';
import 'package:flutter_booktickets_app/ui_screen/theme.dart';
import 'package:flutter_booktickets_app/ui_screen/widgets/button.dart';
import 'package:flutter_booktickets_app/ui_screen/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _endTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String? _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5, 10, 15, 20
  ];
  String? _selectedRepeat = "None";
  List<String?> repeatList = [
    "None", "Daily", "Weekly", "Monthly"
  ];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined,
                    color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400],
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFormUser(isStartTime: true);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400],
                          ),
                        ),
                      )
                  ), //startTime
                  SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFormUser(isStartTime: false);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400],
                          ),
                        ),
                      )
                  ), //endTime
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  underline: Container(height: 0,),
                  icon: Icon(Icons.keyboard_arrow_down,
                  color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400],
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                widget: DropdownButton(
                  underline: Container(height: 0,),
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400],
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  items: repeatList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!, style: subTitleStyle),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: () => _validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode?Colors.white:Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
            backgroundImage: const AssetImage(
                'assets/images/profile.png'
            ),
            backgroundColor: Get.isDarkMode?Colors.grey[100]:Colors.white
        ),
        const SizedBox(width: 20)
      ],
    );
  }
  
  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(), 
        firstDate: DateTime(2015), 
        lastDate: DateTime(2075)
    );

    if(_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    }else {
      print("it's null or something is wrong");
    }
  }
  
  _getTimeFormUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String? _formatedTime = pickedTime.format(context);

    if(pickedTime == null) {
      print("Time canceld");
    }else if(isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    }else if(isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }
  _showTimePicker() {
    // type Error found
    // Error: The argument type 'String?' can't be assigned to the parameter
    //        type 'String' because 'String?' is nullable and 'String' isn't.
    String? hourTimePicker = _startTime?.split(":")[0];
    String? minuteTimePicker = _startTime?.split(":")[1].split(" ")[0];

    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay.now(
          //_startTime ==> 10:30 AM
          // hour: int.parse(hourTimePicker!),
          // minute: int.parse(minuteTimePicker!),
        )
    );
  }

  _colorPallete() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Color",
            style: titleStyle,
          ),
          const SizedBox(height: 8.0,),
          Wrap(
            children: List<Widget>.generate(
                3,
                    (int index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = index;
                      print("$index");
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: index == 0?primaryClr:index == 1?pinkClr:yellowClr,
                      child: _selectedColor == index?const Icon(Icons.done,
                        color: Colors.white,
                        size: 16,
                      ):Container(),
                    ),
                  ),
                )
            ),
          )
        ],
      );
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );
    print("My id is $value");
  }
  _validateDate() {
    var timeDiff = _startTime?.compareTo(_endTime!);

    switch (timeDiff) {
      case 1:
      case 0:
        Get.snackbar("Required", "Plz Check End Time !!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: pinkClr,
            icon: const Icon(Icons.warning_amber_rounded));
        break;
      default:
        if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
          // add to database
          _addTaskToDb();
          Get.back();
        } else if(_titleController.text.isEmpty || _noteController.text.isEmpty) {
          Get.snackbar("Required", "All Fields are required !!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.white,
              colorText: pinkClr,
              icon: const Icon(Icons.warning_amber_rounded));
        }
    }

  }
}
