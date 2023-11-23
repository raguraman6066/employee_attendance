import 'package:employee_attendance/models/user_model.dart';
import 'package:employee_attendance/services/attendance_service.dart';
import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<SlideActionState> key = GlobalKey<SlideActionState>();

  @override
  void initState() {
    Provider.of<AttendaceService>(context, listen: false).getTodayAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendaceService>(context);
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 32),
            child: Text(
              'Welcome',
              style: TextStyle(color: Colors.black54, fontSize: 30),
            ),
          ),
          Consumer<DbService>(builder: (context, dbService, child) {
            return FutureBuilder(
                future: dbService.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data as UserModel;
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user.name != '' ? user.name : 'guest',
                        style: TextStyle(fontSize: 25),
                      ),
                    );
                  }
                  return SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(),
                  );
                });
          }),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 32),
            child: Text(
              'Today\'s status',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 32,
            ),
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Check In',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Divider(),
                    ),
                    Text(
                      attendanceService.attendanceModel?.checkIn ?? '-- / --',
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Check Out',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Divider(),
                    ),
                    Text(
                      attendanceService.attendanceModel?.checkout ?? '-- / --',
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                ))
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat('dd MMMM yyyy').format(DateTime.now()),
              style: TextStyle(fontSize: 20),
            ),
          ),
          StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                );
              }),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Builder(builder: (context) {
              return SlideAction(
                text: attendanceService.attendanceModel?.checkIn == null
                    ? 'Slide to Check In'
                    : 'Slide to Check Out',
                textStyle: TextStyle(color: Colors.black54, fontSize: 18),
                innerColor: Colors.redAccent,
                outerColor: Colors.white,
                key: key,
                onSubmit: () async {
                  await attendanceService.markAttendance(context);
                  key.currentState?.reset();
                },
              );
            }),
          )
        ],
      ),
    ));
  }
}
