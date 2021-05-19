import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plasma_donation/donors.dart';
import 'package:plasma_donation/models/Donor.dart';
import 'donor_input_page.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'map.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position position;
  BitmapDescriptor bitmapImage;
  Uint8List markerIcon;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  DateTime selectedDate = DateTime.now();
  var formattedDate;
  int flag = 0;

  GoogleMapController myController;
  Location location = new Location();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);
  Stream<dynamic> query;
  StreamSubscription subscription;
  Widget _child;

  void initState() {
    getIcon();
    getCurrentLocation();
    getMarkerData();
    //initMarker(specify, specifyId);
    super.initState();
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(
            title: specify['name'],
            snippet: specify['bloodGroup'],
            onTap: () async {
              return showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      height: 180.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  child: Text(
                                    specify['bloodGroup'],
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  radius: 30.0,
                                  backgroundColor:
                                      Color.fromARGB(1000, 221, 46, 68),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    specify['name'],
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                  Text(
                                    "Covid Positive Date: " + specify['covidPositiveDate'],
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () async {
                                  await launch(
                                      "tel:${specify['contactNumber']}");
                                },
                                textColor: Colors.white,
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                color: Color.fromARGB(1000, 221, 46, 68),
                                child: Icon(Icons.phone),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  String message =
                                      "Hello $specify['name'], I am a potential blood donor willing to help you. Reply back if you still need blood.";
                                  launch(
                                      "sms:${specify['contactNumber']}?body=$message");
                                },
                                textColor: Colors.white,
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                color: Color.fromARGB(1000, 221, 46, 68),
                                child: Icon(Icons.message),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            }));

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
      print(markerId);
    });
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    print(Position);
    setState(() {
      position = res;
      _child = Scaffold();
    });

    print(position.latitude);
    print(position.longitude);
  }

  void getIcon() async {
    markerIcon = await getBytesFromAsset('assets/marker2.png', 120);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("home"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    ].toSet();
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setmapstyle(String mapStyle) {
    myController.setMapStyle(mapStyle);
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('donors').get().then((donorData) {
      if (donorData.docs.isNotEmpty) {
        for (int i = 0; i < donorData.docs.length; i++) {
          initMarker(donorData.docs[i].data(), donorData.docs[i].id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Donor donor;
    //final newDonor = new Donor(null, null, null, null, null, null);
    var pos = location.getLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plasma Finder',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list_alt),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DonorsPage()));
              }),
          IconButton(
              icon: Icon(Icons.map_rounded),
              onPressed: () {
                openMapAlert();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapPage()));
                Future.delayed(const Duration(milliseconds: 4500));

              })
        ],
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 50,
            left: 10,
            child: Slider(
              min: 100,
              max: 500,
              divisions: 4,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.green,
              inactiveColor: Colors.green.withOpacity(0.2),
              //onChanged: _updateQuery,
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  markers: Set<Marker>.of(markers.values),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(19.7515, 75.7139), zoom: 6.0),
                  onMapCreated: (GoogleMapController controller) {
                    myController = controller;
                    getJsonFile('assets/customStyle.json').then(setmapstyle);
                  },
                  compassEnabled: true,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                        child: Text(
                          'Donate Plasma',
                        ),
                        color: Colors.redAccent,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DonorInputPage()));
                        }),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RaisedButton(
                      elevation: 100,
                      child: Text(
                        'Request Plasma',
                      ),
                      textColor: Colors.black,
                      color: Colors.redAccent,
                      onPressed: () {
                        openDialogBox();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> openDialogBox() async {
    return showDialog<void>(
      context: this.context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(),
          backgroundColor: Colors.redAccent,
          title: Text(
            'Get Donors Near You',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                MaterialButton(
                    color: Colors.black,
                    child: Text(
                      "Press ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _animateToUser();
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  _animateToUser() async {
    var pos = await location.getLocation();
    myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 13.0,
      tilt: 60,
      bearing: 50,
    )));
  }

 Future<void> openMapAlert() async {
    return showDialog<void>(
        context: this.context,
        builder: (BuildContext dialogContex){
   return AlertDialog(
   shape: RoundedRectangleBorder(),
   backgroundColor: Colors.redAccent,
   title: Text(
   'Input date for map',
   style: TextStyle(color: Colors.white),
   ),
     content: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Row(
         children: <Widget>[
           IconButton(
             onPressed: () => _selectDate(context),
             icon: Icon(FontAwesomeIcons.calendar),
             color: Color.fromARGB(1000, 221, 46, 68),
           ),
           flag == 0
               ? Text(
             "<< Date for Required map",
             style: TextStyle(
                 color: Colors.black54, fontSize: 15.0),
           )
               : Text(formattedDate),
         ],
       ),
     ),
   );
   }
    );
 }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        flag = 1;
      });
    var date = DateTime.parse(selectedDate.toString());
    formattedDate = "${date.day}-${date.month}-${date.year}";
  }
}
