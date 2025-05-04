import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/helper/apis.dart';
import 'ReminderNotificaion.dart';

//________________________________________Uploading Data___________________________________//
Future<void> addData(int formId, String medicienName, dosage, note,
    int reminder, String date, time, nextReminder) async {
  await FirebaseFirestore.instance.collection("users").add({
    'Id': formId,
    'Medicien Name': medicienName,
    'Dosage': dosage,
    'Note': note,
    'Reminder': reminder,
    'Date': date,
    'Time': time,
    'Next Reminder': nextReminder,
    'User ID': APIs.user.uid
  });
}

//___________________________________________Update Data_______________________________________//
Future<void> updateData(
    String id, medicienName, dosage, note, int reminder, date, time) async {
  await FirebaseFirestore.instance.collection("users").doc(id).update({
    'Medicien Name': medicienName,
    'Dosage': dosage,
    'Note': note,
    'Reminder': reminder,
    'Date': date,
    'Time': time,
  });
}

//___________________________________________Update NextReminder_______________________________________//
Future<void> updateNextReminder(String id, nextReminder) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .update({'Next Reminder': nextReminder});
}

//___________________________________________Deleted Data_______________________________________//
Future<void> deleteData(DocumentSnapshot doc) async {
  await FirebaseFirestore.instance.collection("users").doc(doc.id).delete();
}

//___________________________________________SplitTime__________________________________________//
Future<void> getHoursAndMinutes(String id, String medicienName, String dosage,
    String time, int formId, int remidner) async {
  var nextReminderSplit = time.split(':');
  int nextHours = int.parse(nextReminderSplit[0]);
  int nextMinutes = int.parse(nextReminderSplit[1]);
  var dayTime = nextReminderSplit[2];
  if (dayTime == 'PM') {
    nextHours = nextHours + 12;
  }

  nextHours = nextHours + remidner;

  if (nextHours > 24) {
    nextHours = nextHours - 24;
    nextHours.abs();
  }
  // NotificaionReminder().notificaionSchedule(
  // id, medicienName, dosage, formId, nextHours, nextMinutes);
  if (nextHours > 12) {
    nextHours = nextHours - 12;
    dayTime = 'PM';
  } else {
    dayTime = 'AM';
  }

  time = '$nextHours:$nextMinutes:$dayTime';

  updateNextReminder(id, time);
}
