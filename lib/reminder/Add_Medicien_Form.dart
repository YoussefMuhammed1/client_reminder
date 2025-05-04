import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/HomeScreen.dart';
import 'package:test/components/defualt_textfield.dart';
import 'DatabaseOperation.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
//________________________________ControllerIntialized____________________________//
  var medicienNameController = TextEditingController();
  var dosageController = TextEditingController();
  var noteController = TextEditingController();
//________________________________VariableIntialized______________________________//
  Random random = Random(); //Generate ID in Reminder Field
  String date = DateFormat('MM/dd/yyyy').format(DateTime.now());
  String time = DateFormat('hh:mm:a').format(DateTime.now());
  DateTime intialDate = DateTime.now();
  List<int> reminderHours = [2, 6, 8, 12, 24];
  String reminderSelected = '';
  int intialSelected = 0;
  int selected = 2;

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
      //_______________________________MedicienName TextField_____________________________//
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
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
                  //___________________________________Dosage TextField_______________________________//
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
                          prefix: Icons.medication_liquid))
                ],
              ),
              //______________________________________Note TextField_______________________________//
              const SizedBox(height: 30),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: noteController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.note),
                            // icon: Icon(Icons.note),
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
                          //______________________________________How Many TextField_______________________________//
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              keyboardType: null,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.timer),
                                hintText:
                                    "Remind Me Each ${reminderSelected}Hours",
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
                                            //______________________________________Reminder CupertinoPicker_______________________________//
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
                                                        x <
                                                            reminderHours
                                                                .length;
                                                        x++)
                                                      Text(reminderHours[x]
                                                          .toString()),
                                                  ],
                                                  onSelectedItemChanged:
                                                      (value) {
                                                    selected =
                                                        reminderHours[value];
                                                    intialSelected = value;
                                                    setState(() {
                                                      reminderSelected =
                                                          selected.toString();
                                                    });
                                                  }),
                                            ),

                                            //______________________________________TimesInDay Fixed CupertinoPicker_______________________________//
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
                                            //______________________________________Done Button In Reminder CupertinoPicker_______________________________//
                                            Column(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    if (reminderSelected ==
                                                        '') {
                                                      setState(() {
                                                        reminderSelected =
                                                            selected.toString();
                                                      });
                                                    }
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
                  Row(
                    children: [
                      //______________________________________DatTime TextField_______________________________//
                      Expanded(
                        child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.calendar_today),
                              // icon: const Icon(Icons.calendar_today),
                              hintText: "Start Date: $date  /  Time: $time",
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
                                                  date =
                                                      DateFormat('MM/dd/yyyy')
                                                          .format(value);
                                                  time = DateFormat('hh:mm:a')
                                                      .format(value);
                                                  intialDate = value;
                                                });
                                              },
                                            ),
                                          ),
                                          //______________________________________Done Button In DateTime CupertinoPicker_______________________________//
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
                            }),
                      ),
                    ],
                  ),
                ],
              ),

              //______________________________________________Add Button______________________________________//
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
                        addData // Adding Data In FireStore
                            (
                                random.nextInt(1000),
                                medicienNameController.text,
                                dosageController.text,
                                noteController.text,
                                selected,
                                date,
                                time,
                                '');
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 174, 73, 102),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Apply",
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
      ),
    );
  }
}
