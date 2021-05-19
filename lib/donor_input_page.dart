import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
//
import 'main.dart';

class DonorInputPage extends StatefulWidget {
  // double _lat, _lng;
  // DonorInputPage(this._lat, this._lng);
  @override
  _DonorInputPageState createState() => _DonorInputPageState();
}

class _DonorInputPageState extends State<DonorInputPage> {
  Position position;
  final formkey = new GlobalKey<FormState>();
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String _selected = '';
  String _name;
  String _age;
  String _address;
  bool _categorySelected = false;
  String _contactNumber;
  DateTime selectedDate = DateTime.now();
  var formattedDate;
  int flag = 0;
  List<Placemark> placemark;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    //_loadCurrentUser();
    //getAddress();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    print(Position);
    setState(() {
      position = res;
      // _child = mapWidget();
    });

    print(position.latitude);
    print(position.longitude);
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

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Blood Request Submitted'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  formkey.currentState.reset();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Color.fromARGB(1000, 221, 46, 68),
                ),
              ),
            ],
          );
        });
  }

  // void getAddress() async {
  //   placemark =
  //   await placemarkFromCoordinates(position.latitude, position.longitude);
  //   _address = placemark[0].name.toString() +
  //       "," +
  //       placemark[0].locality.toString() +
  //       ", Postal Code:" +
  //       placemark[0].postalCode.toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Donator Registration",
          style: TextStyle(
            fontSize: 50.0,
            fontFamily: "SouthernAire",
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.reply,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ClipRRect(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0)),
        child: Container(
          height: 800.0,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: DropdownButton(
                                hint: Text(
                                  'Please choose a Blood Group',
                                  style: TextStyle(
                                    color: Color.fromARGB(1000, 221, 46, 68),
                                  ),
                                ),
                                iconSize: 40.0,
                                items: _bloodGroup.map((val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selected = newValue;
                                    this._categorySelected = true;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              _selected,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Color.fromARGB(1000, 221, 46, 68),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Name',
                            icon: Icon(
                              FontAwesomeIcons.envelopeOpenText,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) => value.isEmpty
                              ? "Quantity field can't be empty"
                              : null,
                          onSaved: (value) => _name = value,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Age',
                            icon: Icon(
                              FontAwesomeIcons.sortNumericUp,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) => value.isEmpty
                              ? "Phone Number field can't be empty"
                              : null,
                          onSaved: (value) => _age = value,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
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
                              "<< Covid Positive Tested Date",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 15.0),
                            )
                                : Text(formattedDate),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            icon: Icon(
                              FontAwesomeIcons.mobile,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) => value.isEmpty
                              ? "Phone Number field can't be empty"
                              : null,
                          onSaved: (value) => _contactNumber = value,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (!formkey.currentState.validate()) return;
                          formkey.currentState.save();
                          final Map<String, dynamic> DonorDetails = {
                            'bloodGroup': _selected,
                            'name': _name,
                            'covidPositiveDate': formattedDate,
                            'contactNumber': _contactNumber,
                            'age':_age,
                            'location': new GeoPoint(position.latitude, position.longitude),
                            'address': _address,
                          };
                          FirebaseFirestore.instance.collection('donors').add(DonorDetails).then((result) {
                            dialogTrigger(context);
                          }).catchError((e) {
                            print(e);
                          });
                        },
                        textColor: Colors.white,
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        color: Color.fromARGB(1000, 221, 46, 68),
                        child: Text("SUBMIT"),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

