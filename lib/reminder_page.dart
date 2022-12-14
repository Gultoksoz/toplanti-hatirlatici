import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:meetingreminder_project/SharedPrefFayda.dart';
import 'package:meetingreminder_project/drafts.dart';
import 'package:meetingreminder_project/expired_meetings.dart';
import 'package:meetingreminder_project/viewModel.dart';
import 'add_meeting.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'main.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => ReminderPageState();
}

class ReminderPageState extends State<ReminderPage> {
  var adminControl = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var email;
  var secilenSayfa = "Toplantılar";
  var baslik;
  String mesaj = '';

  @override
  void initState() {

    SharedPrefFayda.getEmailPref().then((value) => email = value);
    var oneSecond = const Duration(seconds: 20);
    Timer.periodic(oneSecond, (timer) async {
      setState(() {});
    });
    adminKontrol();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(secilenSayfa,
              style: TextStyle(color: Colors.white)),
        ),
        endDrawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Text("Menü", style: TextStyle(color:Colors.white,fontSize: 20)),
          ),
          ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: () {
                SharedPrefFayda.prefEmailSil(SharedPrefFayda.getEmailPref());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),
          Visibility(
              visible: adminControl == true,
              child: ListTile(
                  leading: Icon(Icons.draw),
                  title: const Text('Taslaklar'),
                  onTap: () {
                    secilenSayfa = 'Taslaklar';
                    setState(() {});
                  }))
        ])),
        floatingActionButton: Visibility(
          visible: adminControl == true,
          child: FloatingActionButton(
            onPressed: () {
              secilenSayfa = 'Toplantı Ekle';
              setState(() {});
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.black, //icon inside button
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          shape: CircularNotchedRectangle(),
          //shape of notch
          notchMargin: 5,
          //notch margin between floating button and bottom appbar
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.alarm_on,
                          color: Colors.white,
                        )),
                    Text(
                      "Geçmiş Toplantılar",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
                onTap: () {
                  secilenSayfa = "Geçmiş Toplantılar";

                  SharedPrefFayda.gelecekToplantilarColor = Colors.white;
                  setState(() {});
                },
              ),
              InkWell(
                child: Row(
                  children: [
                    Text(
                      "Gelecek Toplantılar",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.alarm,
                          color: Colors.white,
                        )),
                  ],
                ),
                onTap: () {
                  secilenSayfa = "Toplantılar";

                  SharedPrefFayda.gelecekToplantilarColor = Colors.white;
                  setState(() {});
                },
              )
            ],
          ),
        ),
        body: bodyOlustur());
  }

  Widget listItem(int index, streamSnapshot) {
    return Card(
      color: Colors.blueGrey[60],
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      elevation: 20,
      margin: EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Column(children: [
          Container(
            height: 60,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 60.0),
                    child: Column(
                      children: [
                        Text(
                            streamSnapshot.data?.docs[index]['baslik']
                                .toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Container(
                          child: CountdownTimer(
                            endTime: dateParse(streamSnapshot.data?.docs[index]
                                    ['tarihsaat'])
                                .millisecondsSinceEpoch,
                            textStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white),
                            //onEnd: onEnd(index, streamSnapshot)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    width: 50,
                    child: Visibility(
                        visible: adminControl == true,
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: Text("Toplantıyı İptal Et"),
                                    content: Text(
                                        "Toplantıyı iptal etmek istiyor musunuz? Kullanıcılar bu işlem sonunda bilgilendirilecektir."),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                        ),
                                        child: Text("Listeye Dön"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ReminderPage()));
                                        },
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.black),
                                        ),
                                        child: Text("Toplantıyı İptal Et"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          mesaj = streamSnapshot
                                              .data?.docs[index]['baslik'];
                                          mesaj += ' adlı toplantı iptal oldu.';
                                          toplantiIptal(index, streamSnapshot);
                                          bitenToplantiyiSil(
                                              index, streamSnapshot);
                                          NotificationVM.bildirimGonder(
                                              mesaj,
                                              DateFormat("dd.MM.yyyy - HH:mm ")
                                                  .format(streamSnapshot
                                                          .data?.docs[index]
                                                      ['tarihsaat']));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.clear, color: Colors.white))))
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30)),
              color: Colors.black87,
            ),
          ),
          Container(
              // etiketlerin olduğu
              child: Row(children: [
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text('Toplantı Konusu: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            streamSnapshot.data?.docs[index]['konu'],
                            textAlign: TextAlign.left,
                          )),
                    ])),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.red, width: 3.0),
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text('Toplantı Zamanı: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          streamSnapshot.data?.docs[index]['tarihsaat'],
                          textAlign: TextAlign.left,
                        )),
                  ])),
              new Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text('Toplantı Mekanı: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          streamSnapshot.data?.docs[index]['mekan'],
                          textAlign: TextAlign.left,
                        )),
                  ])),
              const Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text('Departman: ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          streamSnapshot.data?.docs[index]['departman'],
                          textAlign: TextAlign.left,
                        )),
                  ]))
            ]),
          ])),
        ]),
      ),
    );
  }

  static DateTime dateParse(String date) {
    var parsedDate = DateFormat("dd-M-yyyy hh:mm:ss").parse(date);
    return parsedDate;
  }

  Future<bool> adminKontrol() async {
    var email = FirebaseAuth.instance.currentUser?.email.toString();
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('admins').get();
    final List<DocumentSnapshot> documents = result.docs;

    documents.forEach((snapshot) {
      if (snapshot.get('email') == email ||
          SharedPrefFayda.getEmailPref() == email) {
        adminControl = true;
        setState(() {});
      }
    });
    return false;
  }

  toplantiKontrol(streamSnapshot, index) async {
    await toplantiBitisKontrol(streamSnapshot, index);
  }

  bitenToplantiyiAl(index, streamSnapshot) async {
    Map<String, dynamic> eklenecekToplanti = <String, dynamic>{};

    eklenecekToplanti['baslik'] = streamSnapshot.data?.docs[index]['baslik'];
    eklenecekToplanti['konu'] = streamSnapshot.data?.docs[index]['konu'];
    eklenecekToplanti['mekan'] = streamSnapshot.data?.docs[index]['mekan'];
    eklenecekToplanti['departman'] =
        streamSnapshot.data?.docs[index]['departman'];
    eklenecekToplanti['tarihsaat'] =
        streamSnapshot.data?.docs[index]['tarihsaat'];

    await bitenToplantiyiSil(index, streamSnapshot);
    await firestore.collection('expiredtoplanti').add(eklenecekToplanti);

    setState(() {});
  }

  bitenToplantiyiSil(int index, streamSnapshot) async {
    await FirebaseFirestore.instance
        .collection("toplantilar")
        .doc(streamSnapshot.data?.docs[index].id)
        .delete();
  }

  Widget bodyOlustur() {
    if (secilenSayfa == 'Geçmiş Toplantılar') {
      return ExpiredPage();
    } else if (secilenSayfa == 'Toplantılar') {
      StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('toplantilar').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            int a = streamSnapshot.data?.docs.length as int;
            for (var i = 0; i <= a; i++) {
              toplantiKontrol(streamSnapshot, i);
            }

            return ListView.builder(
                itemCount: streamSnapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return listItem(index, streamSnapshot);
                });
          });
    } else if (secilenSayfa == 'Toplantı Ekle') {
      return AddMeetingPage();
    } else if (secilenSayfa == 'Taslaklar') {
      return DraftPage();
    }
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('toplantilar').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          int a = streamSnapshot.data?.docs.length as int;
          for (var i = 0; i <= a; i++) {
            toplantiKontrol(streamSnapshot, i);
          }

          return ListView.builder(
              itemCount: streamSnapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return listItem(index, streamSnapshot);
              });
        });
  }

  Future<bool> toplantiBitisKontrol(streamSnapshot, index) async {
    if (dateParse(streamSnapshot.data?.docs[index]['tarihsaat'])
                .millisecondsSinceEpoch ==
            DateTime.now().millisecondsSinceEpoch ||
        dateParse(streamSnapshot.data?.docs[index]['tarihsaat'])
                .millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
      await bitenToplantiyiAl(index, streamSnapshot);

      return true;
    } else {
      return false;
    }
  }

  toplantiIptal(int index, streamSnapshot) {
    FirebaseFirestore.instance
        .collection("toplantilar")
        .doc(streamSnapshot.data?.docs[index].id)
        .delete();
  }
}
