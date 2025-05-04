// import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';

// class NotificaionReminder {
// //_______________________________________NotificaionIntialized_______________________________________//
//   Future<void> notificationIntialize(
//       String channelKey, title, body, int formId) async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: channelKey,
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for basic tests',
//           playSound: true,
//           channelShowBadge: true,
//           importance: NotificationImportance.High,
//         )
//       ],
//     );
// //_________________________________________NotificaionRequested_______________________________________//
//     await AwesomeNotifications().requestPermissionToSendNotifications(
//       channelKey: channelKey,
//     );
// //__________________________________________NotificaionCreate______________________________________//
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: formId,
//         channelKey: channelKey,
//         title: title,
//         body: body,
//         displayOnBackground: true,
//         displayOnForeground: true,
//         largeIcon: 'asset://assets/remind.png',
//       ),
//       actionButtons: <NotificationActionButton>[
//         NotificationActionButton(
//           key: 'yes',
//           label: 'Yes',
//           actionType: ActionType.DismissAction,
//           isDangerousOption: true,
//         ),
//       ],
//     );
//   }

// //__________________________________________NotificaionDelete_____________________________________//
//   Future<void> notificaionSchedule(
//       String channelKey, title, body, int formId, hours, minutes) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: formId,
//         channelKey: channelKey,
//         title: title,
//         body: "Reminder For $body",
//         displayOnBackground: true,
//         displayOnForeground: true,
//         largeIcon: 'asset://assets/remind.png',
//       ),
//       schedule: NotificationCalendar(
//         hour: hours,
//         minute: minutes,
//         repeats: false,
//       ),
//       actionButtons: <NotificationActionButton>[
//         NotificationActionButton(
//           key: 'yes',
//           label: 'Yes',
//           actionType: ActionType.DismissAction,
//           isDangerousOption: true,
//         ),
//       ],
//     );
//   }

// //__________________________________________NotificaionDelete_____________________________________//
//   Future<void> scheduleDelete(String channelKey, int formId) async {
//     AwesomeNotifications().cancelNotificationsByChannelKey(channelKey);
//     AwesomeNotifications().cancelSchedulesByChannelKey(channelKey);
//     AwesomeNotifications().cancelSchedule(formId);
//   }
// }
