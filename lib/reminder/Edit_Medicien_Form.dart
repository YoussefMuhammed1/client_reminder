// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/HomeScreen.dart';
import '../components/defualt_textfield.dart';
import 'DatabaseOperation.dart';

class EditForm extends StatefulWidget {
  final id;
  final formId;
  final name;
  final dose;
  final note;
  final reminder;
  final date;
  final time;
  final nextReminder;
  const EditForm(
      {super.key,
      this.id,
      this.formId,
      this.name,
      this.dose,
      this.note,
      this.reminder,
      this.date,
      this.time,
      this.nextReminder});

  @override
  State<EditForm> createState() => _EditFormtState();
}

class _EditFormtState extends State<EditForm> {
  //________________________________ControllerIntialized____________________________//
  TextEditingController medicienNameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController noteController = TextEditingController();
//__________________________________VariableIntialized______________________________//
  late String date;
  late String time;
  late DateTime intialDate;
  List<int> reminderHours = [2, 6, 8, 12, 24];
  String reminderSelected = '';
  int intialSelected = 0;
  int selected = 0;
//______________________________________IntialState__________________________________//
  @override
  void initState() {
    medicienNameController.text = widget.name;
    dosageController.text = widget.dose;
    noteController.text = widget.note;
    selected = widget.reminder;
    reminderSelected = widget.reminder.toString();
    intialSelected = reminderHours.indexOf(widget.reminder);
    date = widget.date;
    time = widget.time;
    intialDate = DateFormat('MM/dd/yyyy hh:mm:a').parse('$date $time');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //__________________________________AppBar________________________________//
      appBar: AppBar(
        title: const Text(
          "Reminder Form",
        ),
        backgroundColor: Color.fromARGB(255, 174, 73, 102),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      //___________________________MedicienName TextField__________________________//
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            const SizedBox(height: 80),
            Row(
              children: <Widget>[
                Expanded(
                    child: defaultFormField(
                        controller: medicienNameController,
                        validate: (value) {
                          if (value.isEmpty) {
                            return "Please enter Medicien Name";
                          }
                        },
                        label: "Medicien Name",
                        prefix: Icons.medication)),
                //_______________________________Dosage TextField_____________________________//
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: defaultFormField(
                        controller: dosageController,
                        validate: (value) {
                          if (value.isEmpty) {
                            return "Please enter Doseage";
                          }
                        },
                        label: "Doseage",
                        prefix: Icons.medication_liquid)),
              ],
            ),
            //_________________________________Note TextField_______________________________//
            const SizedBox(height: 30),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: noteController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.note),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.note),
                          labelText: 'Note',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      children: [
                        //__________________________________How Many TextField_____________________________//
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            keyboardType: null,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.timer),
                              hintText:
                                  "Remind Me Each $reminderSelected Hours",
                            ),
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      color: Colors.white,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          //________________________________Reminder CupertinoPicker____________________________//
                                          Expanded(
                                            child: CupertinoPicker(
                                                backgroundColor: Colors.white,
                                                itemExtent: 30,
                                                scrollController:
                                                    FixedExtentScrollController(
                                                        initialItem:
                                                            intialSelected),
                                                children: <Widget>[
                                                  for (int x = 0;
                                                      x < reminderHours.length;
                                                      x++)
                                                    Text(reminderHours[x]
                                                        .toString()),
                                                ],
                                                onSelectedItemChanged:
                                                    (int value) {
                                                  intialSelected = value;
                                                  setState(() {
                                                    selected =
                                                        reminderHours[value];
                                                    reminderSelected =
                                                        selected.toString();
                                                  });
                                                }),
                                          ),

                                          //_________________________________TimesInDay Fixed CupertinoPicker____________________________//
                                          Expanded(
                                            child: CupertinoPicker(
                                                backgroundColor: Colors.white,
                                                itemExtent: 30,
                                                diameterRatio: 1.0,
                                                scrollController:
                                                    FixedExtentScrollController(
                                                        initialItem: 0),
                                                children: const [
                                                  Text("Time In Days"),
                                                ],
                                                onSelectedItemChanged:
                                                    (int value) {}),
                                          ),
                                          //______________________________Done Button In Reminder CupertinoPicker__________________________//
                                          Column(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Apply"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                //Can Add Row Here
                Row(
                  children: [
                    //______________________________________DatTime TextField_______________________________//
                    Expanded(
                      child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            // icon: const Icon(Icons.calendar_today),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.calendar_today),
                            hintText: "Start Date: $date  /  Time: $time",
                          ),
                          onTap: () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        //______________________________________DateTime CupertinoPicker_______________________________//
                                        Expanded(
                                          child: CupertinoDatePicker(
                                            backgroundColor: Colors.white,
                                            initialDateTime: intialDate,
                                            maximumYear: 2030,
                                            minimumYear: 2020,
                                            use24hFormat: false,
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            onDateTimeChanged:
                                                (DateTime value) {
                                              setState(() {
                                                date = DateFormat('MM/dd/yyyy')
                                                    .format(value);
                                                time = DateFormat('hh:mm:a')
                                                    .format(value);
                                                intialDate = value;
                                              });
                                            },
                                          ),
                                        ),
                                        //__________________________________Done Button In DateTime CupertinoPicker_____________________________//
                                        Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Update"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                    ),
                  ],
                ),
              ],
            ),

            //_____________________________________________________Update Button__________________________________________//
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      updateData // Adding Data In FireStore
                          (
                        widget.id,
                        medicienNameController.text,
                        dosageController.text,
                        noteController.text,
                        selected,
                        date,
                        time,
                      );
                      if (widget.time != time || widget.reminder != selected) {
                        getHoursAndMinutes(
                            widget.id,
                            medicienNameController.text,
                            dosageController.text,
                            widget.nextReminder,
                            widget.formId,
                            selected);
                      }
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 174, 73, 102),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Update",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.add,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
