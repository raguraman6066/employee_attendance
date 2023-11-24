import 'package:employee_attendance/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

import '../models/attendance_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final attendaceService = Provider.of<AttendaceService>(context);
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20, top: 60, bottom: 10),
          child: Text(
            'My Attendance',
            style: TextStyle(fontSize: 25),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              attendaceService.attendanceHistoryMonth,
              style: TextStyle(fontSize: 25),
            ),
            OutlinedButton(
                onPressed: () async {
                  final selectedDate =
                      await SimpleMonthYearPicker.showMonthYearPickerDialog(
                          context: context, disableFuture: true);
                  String pickedMonth =
                      DateFormat('MMMM yyyy').format(selectedDate);
                  attendaceService.attendanceHistoryMonth = pickedMonth;
                },
                child: Text('Pick a month')),
          ],
        ),
        Expanded(
            child: FutureBuilder<List<AttendanceModel>>(
          future: attendaceService.getAttendanceHistory(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    AttendanceModel attendancedata = snapshot.data[index];
                    return Container(
                      margin: EdgeInsets.only(
                          top: 12, left: 20, right: 20, bottom: 10),
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 10),
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                )),
                            child: Center(
                              child: Text(
                                DateFormat('EE \n dd')
                                    .format(attendancedata.createdAt),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Check in',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              SizedBox(
                                width: 80,
                                child: Divider(),
                              ),
                              Text(
                                attendancedata.checkIn,
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
                                    fontSize: 20, color: Colors.black54),
                              ),
                              SizedBox(
                                width: 80,
                                child: Divider(),
                              ),
                              Text(
                                attendancedata.checkout?.toString() ?? '-- /--',
                                style: TextStyle(fontSize: 25),
                              )
                            ],
                          )),
                          SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Text(
                  'No data availble',
                  style: TextStyle(fontSize: 25),
                );
              }
            }
            return LinearProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.grey,
            );
          },
        ))
      ],
    );
  }
}
