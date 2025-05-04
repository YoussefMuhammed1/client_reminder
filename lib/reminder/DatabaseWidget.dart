import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DatabaseOperation.dart';
import 'Edit_Medicien_Form.dart';
import 'ReminderNotificaion.dart';

// ignore: camel_case_types
class DatabaseWidget extends StatefulWidget {
  //__________________________Intialized_________________________//
  final DocumentSnapshot documentSnapshot;
  final String id;
  final int formId;
  final String medicienName;
  final String dosage;
  final String note;
  final int reminder;
  final String date;
  final String time;
  final String nextReminderDatabase;
  final String userid;
  //__________________________Constructor_________________________//
  const DatabaseWidget({
    super.key,
    required this.documentSnapshot,
    required this.id,
    required this.formId,
    required this.medicienName,
    required this.dosage,
    required this.note,
    required this.reminder,
    required this.date,
    required this.time,
    required this.nextReminderDatabase,
    required this.userid,
  });

  @override
  State<DatabaseWidget> createState() => _DatabaseWidgetState();
}

// ignore: camel_case_types
class _DatabaseWidgetState extends State<DatabaseWidget>
    with TickerProviderStateMixin {
  late String dateTimeNow;
  late String dateTimeDatabase;
  late String timeNow;
  Timer? _timer;
  //_______________________________IntialState___________________________//
  @override
  void initState() {
    //_______________________________DurationTimer___________________________//
    Timer.periodic(const Duration(seconds: 1), (timer) {
      dateTimeDatabase = '${widget.date} ${widget.time}';
      dateTimeNow = DateFormat('MM/dd/yyyy hh:mm:a').format(DateTime.now());

      if (dateTimeDatabase == dateTimeNow) {
        // NotificaionReminder().notificationIntialize(
        //     widget.id, widget.medicienName, widget.dosage, widget.formId);
        // getHoursAndMinutes(widget.id, widget.medicienName, widget.dosage,
        //     widget.time, widget.formId, widget.reminder);
        // timer.cancel();
      }
    });
    //_______________________________DurationTimer___________________________//
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeNow = DateFormat('h:m:a').format(DateTime.now());

      if (widget.nextReminderDatabase == timeNow) {
        getHoursAndMinutes(widget.id, widget.medicienName, widget.dosage,
            widget.nextReminderDatabase, widget.formId, widget.reminder);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  //___________________________________Widget_______________________________//
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(4, 4),
            ),
          ],
        ),
//___________________________________ListTitle_______________________________//
        child: ListTile(
//__________________________________Edit Button_______________________________//

          title: Text(
            "${widget.medicienName}",
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Text(
              "Dosage: ${widget.dosage} Gm\nStart Date: ${widget.date} - ${widget.time}\nNext Reminder ${widget.nextReminderDatabase}",
              style: const TextStyle(fontSize: 15)),
//__________________________________Deleted Button_______________________________//
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: const Icon(
                  Icons.edit,
                  size: 25,
                  color: Colors.green,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditForm(
                                id: widget.id,
                                formId: widget.formId,
                                name: widget.medicienName,
                                dose: widget.dosage,
                                note: widget.note,
                                reminder: widget.reminder,
                                date: widget.date,
                                time: widget.time,
                                nextReminder: widget.nextReminderDatabase,
                              )));
                },
              ),
              InkWell(
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onTap: () {
                  deleteData(widget.documentSnapshot); //Edit Items
                  // NotificaionReminder()
                  //     .scheduleDelete(widget.id, widget.formId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
