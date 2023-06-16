
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:convert';

import 'API.dart';
import 'HomePage.dart';
import 'Tempat.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.User, required this.tempat}) : super(key: key);
  final User;
  final Tempat tempat;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DateTime datePicked;
  late TimeOfDay timePicked1;
  late TimeOfDay timePicked2;
  late TextEditingController timeController1;
  late TextEditingController timeController2;
  late TextEditingController dateController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late int durasi;
  final _unfocusNode = FocusNode();
  bool availability = false;
  bool completeDate = false;
  bool completeTime1 = false;
  bool completeTime2 = false;
  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    dateController.text = "Tanggal";

    timePicked1 = TimeOfDay.now();
    timeController1 = TextEditingController();
    timeController1.text = "--:--";

    timePicked2 = TimeOfDay.now();
    timeController2 = TextEditingController();
    timeController2.text = "--:--";
  }

  @override
  void dispose() {

    super.dispose();
  }
  void _availability() async{
    if(completeTime1 && completeTime2 && completeDate){
      var data = {
        'tanggal': datePicked.toString(),
        'waktuAwal' : '${timePicked1.hour}:${timePicked1.minute}',
        'waktuAkhir' : '${timePicked2.hour}:${timePicked2.minute}',
        'namaTempat' : "${widget.tempat.nama}",
      };
      var res = await Network().post(data, 'availability');
      var body = jsonDecode(res.body);
      if(res.statusCode == 200){
        setState(() {
          availability = true;
        });
      }else{
        setState(() {
          availability = false;
        });
      }
    }

  }

  void _order() async{
    var data = {
      'tanggal': datePicked.toString(),
      'waktuAwal' : '${timePicked1.hour}:${timePicked1.minute}',
      'waktuAkhir' : '${timePicked2.hour}:${timePicked2.minute}',
      'namaTempat' : "${widget.tempat.nama}",
      'fullname' : "${widget.User['name']}",
      'org' : "${widget.User['org']}",
    };
    var res = await Network().post(data, 'availability');
    var body = jsonDecode(res.body);
    if(res.statusCode == 200){
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => HomePage()
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F4F8),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Kembali',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://picsum.photos/seed/11/600',
                      width: 160,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'Hello World',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Text(
                  'Deskripsi',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${widget.tempat.deskripsi}',
                textAlign: TextAlign.justify,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Text(
                  'Fasilitas : ${widget.tempat.fasilitas}',
                ),
              ),
              Text(
                'Kapasitas : ${widget.tempat.kapasitas} Orang',
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Color(0x00FFFFFF),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tanggal',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: TextFormField(
                                controller: dateController,
                                autofocus: true,
                                readOnly:true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  contentPadding:
                                  EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
                                ),
                                onTap: () {

                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      onConfirm: (date) {
                                        datePicked = date;
                                        setState(() {
                                          dateController.text = "${date.day}/${date.month}/${date.year}";
                                          completeDate = true;
                                        });
                                        _availability();
                                      }, currentTime: DateTime.now(), locale: LocaleType.id);
                                }
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Text(
                              'Jam',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            children:[
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                    controller: timeController1,
                                    autofocus: true,
                                    readOnly:true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Awal',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),

                                    ),
                                    onTap:() async {
                                      TimeOfDay? pickedTime =  await showTimePicker(
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                        initialEntryMode: TimePickerEntryMode.input,
                                      );

                                      if(pickedTime != null ){//output 10:51 PM
                                        DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                                        //converting to DateTime so that we can further format on different pattern.

                                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

                                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                                        setState(() {
                                          timeController1.text = formattedTime;
                                          timePicked1 = pickedTime;
                                          completeTime1 = true;
                                        });
                                        _availability();
                                      }
                                    }
                                ),
                              ),
                              Text("Sampai"),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                    controller: timeController2,
                                    autofocus: true,
                                    readOnly:true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Akhir',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),

                                    ),
                                    onTap:() async {
                                      TimeOfDay? pickedTime2 =  await showTimePicker(
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                        initialEntryMode: TimePickerEntryMode.input,
                                      );

                                      if(pickedTime2 != null ){//output 10:51 PM
                                        DateTime parsedTime = DateFormat.jm().parse(pickedTime2.format(context).toString());
                                        //converting to DateTime so that we can further format on different pattern.

                                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

                                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                                        setState(() {
                                          timeController2.text = formattedTime;
                                          timePicked2 = pickedTime2;
                                          completeTime2 = true;

                                        });
                                        _availability();
                                      }
                                    }
                                ),
                              )
                            ]
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Text(
                              'Status',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text( availability ? 'TERSEDIA' : "TIDAK TERSEDIA",
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: availability ? Color(0xFF06981D) : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                if(availability) {
                                  _order();
                                }
                              },
                              child: Text('Reservasi', style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(150,40),
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                backgroundColor: Color(0xFF06981D),

                                elevation: 3,

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
