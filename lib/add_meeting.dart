// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meetingreminder_project/custom_dialog.dart';
import 'package:meetingreminder_project/drafts.dart';
import 'package:meetingreminder_project/expired_meetings.dart';
import 'package:meetingreminder_project/reminder_page.dart';
import 'package:meetingreminder_project/viewModel.dart';

class AddMeetingPage extends StatefulWidget {
  const AddMeetingPage({Key? key}) : super(key: key);

  @override
  State<AddMeetingPage> createState() => AddMeetingPageState();
}

class AddMeetingPageState extends State<AddMeetingPage> {
  final toplantiYeriController = TextEditingController();
  final mySubjectController = TextEditingController();
  final toplantiDepartmanController = TextEditingController();
  final toplantiAdiController = TextEditingController();
  final fcmToken = FirebaseMessaging.instance.getToken();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  getToken() {
    _firebaseMessaging.getToken().then((value) {
      print(value);
    });
  }

  TextEditingController dateinput = TextEditingController();
  DateTime secilenTarih = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    getToken();
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            //********tOPLANTI ADI*/
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                controller: toplantiAdiController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    labelText: 'Toplant?? Ad??',
                    hintText: 'Toplant??n??n ba??l??????n giriniz'))),
        SizedBox(height: 10),
        Padding(
            //******TOPLANTIYI DUZENLEYEN */
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                controller: toplantiYeriController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    labelText: 'Toplant?? Yeri',
                    hintText: 'Toplant?? Yerini Giriniz'))),
        SizedBox(height: 10),
        Padding(
            //********tOPLANTI KONUSU */
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                controller: mySubjectController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    labelText: 'Konu',
                    hintText:
                        'Toplant?? konusu hakk??nda k??sa bir bilgi veriniz'))),
        SizedBox(height: 10),
        Padding(
            //******TOPLANTIYI MUHATAPLARI */
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
                controller: toplantiDepartmanController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    labelText: 'Departman',
                    hintText: 'Toplant??ya gelecek departman?? giriniz'))),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () async {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2010, 3, 5, 0, 0),
                    maxTime: DateTime(2100, 6, 6, 0, 0), onConfirm: (val) {
                  secilenTarih = val;
                  setState(() {});
                }, currentTime: DateTime.now(), locale: LocaleType.tr);
              },
              child: SizedBox(
                width: 340,
                child: Text(
                    DateFormat('dd.MM.yyyy ??? kk:mm')
                        .format(secilenTarih)
                        .toString(),
                    textAlign: TextAlign.center),
              )),
        ),
        //SizedBox(height: 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: (() async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Toplant?? Bilgileri Do??rulama"),
                      content: new Text(
                          'Ba??l??k: ${toplantiAdiController.text}\nKonu: ${mySubjectController.text}\nMekan: ${toplantiYeriController.text}\nDepartman: ${toplantiDepartmanController.text}\nTarih ve Saat: ${DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih)}'),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: new Text("Geri D??n"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: new Text("Do??rula"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await veriEkle();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
              child: SizedBox(
                  width: 340,
                  child: Text('Ekle', textAlign: TextAlign.center))),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: (() async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Toplant?? Bilgileri Do??rulama"),
                      content: new Text(
                          'Ba??l??k: ${toplantiAdiController.text}\nKonu: ${mySubjectController.text}\nMekan: ${toplantiYeriController.text}\nDepartman: ${toplantiDepartmanController.text}\nTarih ve Saat: ${DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih)}'),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: new Text("Geri D??n"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          child: new Text("Do??rula"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await taslakEkle();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
              child: SizedBox(
                  width: 340,
                  child: Text('Taslak Olarak Kaydet',
                      textAlign: TextAlign.center))),
        )
      ],
    )));
  }

  veriEkle() async {
    if (secilenTarih.millisecondsSinceEpoch ==
            DateTime.now().millisecondsSinceEpoch ||
        secilenTarih.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
      Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
      eklenecekToplanti['baslik'] = toplantiAdiController.text;
      eklenecekToplanti['konu'] = mySubjectController.text;
      eklenecekToplanti['mekan'] = toplantiYeriController.text;
      eklenecekToplanti['departman'] = toplantiDepartmanController.text;
      eklenecekToplanti['tarihsaat'] =
          DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih);
      await NotificationVM.bildirimGonder(toplantiAdiController.text,
          DateFormat("dd.MM.yyyy - HH:mm ").format(secilenTarih));
      await firestore.collection('expiredtoplanti').add(eklenecekToplanti);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Ge??mi?? Tarihli Kay??t ????leminiz Tamamlanm????t??r."),
            content: new Text(
                "Toplant??y?? Ge??mi?? Toplant??lar listesinde g??rebilirsiniz."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: new Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ExpiredPage()));
                },
              ),

              //TODO: toplant??lar aras??nda s??ralama yap
              //TODO: tarihi yakla??anlar renk de??i??tirecek
              //TODO: localde kat??ld??????m toplant??lar falan tutulsun. SQFLite
            ],
          );
        },
      );
    } else {
      Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
      eklenecekToplanti['baslik'] = toplantiAdiController.text;
      eklenecekToplanti['konu'] = mySubjectController.text;
      eklenecekToplanti['mekan'] = toplantiYeriController.text;
      eklenecekToplanti['departman'] = toplantiDepartmanController.text;
      eklenecekToplanti['tarihsaat'] =
          DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih);
      await firestore.collection('toplantilar').add(eklenecekToplanti);
      await NotificationVM.bildirimGonder(toplantiAdiController.text,
          DateFormat("dd.MM.yyyy - HH:mm ").format(secilenTarih));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Kaydedildi."),
            content: Text("Toplant??y?? listede g??rebilirsiniz."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text("Listeye D??n"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReminderPage()));
                },
              ),
            ],
          );
        },
      );
    }
  }

  taslakEkle() async {
    if (secilenTarih.millisecondsSinceEpoch ==
            DateTime.now().millisecondsSinceEpoch ||
        secilenTarih.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
      Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
      eklenecekToplanti['baslik'] = toplantiAdiController.text;
      eklenecekToplanti['konu'] = mySubjectController.text;
      eklenecekToplanti['mekan'] = toplantiYeriController.text;
      eklenecekToplanti['departman'] = toplantiDepartmanController.text;
      eklenecekToplanti['tarihsaat'] =
          DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih);
      await firestore.collection('drafts').add(eklenecekToplanti);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Taslak Kaydedildi"),
            content: new Text(
                "Taslaklar k??sm??ndan toplant??y?? d??zenlemeye devam edebilirsiniz"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: new Text("Taslaklar"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DraftPage()));
                },
              ),
            ],
          );
        },
      );
    } else {
      Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};
      eklenecekToplanti['baslik'] = toplantiAdiController.text;
      eklenecekToplanti['konu'] = mySubjectController.text;
      eklenecekToplanti['mekan'] = toplantiYeriController.text;
      eklenecekToplanti['departman'] = toplantiDepartmanController.text;
      eklenecekToplanti['tarihsaat'] =
          DateFormat("dd-MM-yyyy HH:mm:ss").format(secilenTarih);
      await firestore.collection('toplantilar').add(eklenecekToplanti);
      await NotificationVM.bildirimGonder(toplantiAdiController.text,
          DateFormat("dd.MM.yyyy - HH:mm ").format(secilenTarih));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Kaydedildi."),
            content: new Text("Toplant??y?? listede g??rebilirsiniz."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: new Text("Listeye D??n"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReminderPage()));
                },
              ),
            ],
          );
        },
      );
    }
  }
}
