import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'homePage.dart';

class DonorInputPage extends StatefulWidget {
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
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;


  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    print(Position);
    setState(() {
      position = res;
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
            title: Text('Congratulations!'),
            content: Text('You are a donor now'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Donor's Registration",
          style: TextStyle(
            fontSize: 30.0,
            // fontFamily: "SouthernAire",
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
                          validator: (value) =>
                          value.isEmpty
                              ? "Please enter your name"
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
                          validator: (value) =>
                          value.isEmpty
                              ? "Please enter your age"
                              : checkAge(int.parse(value)),
                          onSaved: (value) => _age = value,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Weight(in kgs)',
                            icon: Icon(
                              FontAwesomeIcons.sortNumericUp,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) =>
                          value.isEmpty
                              ? "Please enter your weight"
                              : checkWeight(int.parse(value)),
                          onSaved: (value) => _age = value,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(18.0),
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
                          validator: (value) =>
                          value.isEmpty
                              ? "Please enter your phone number"
                              : null,
                          onSaved: (value) => _contactNumber = value,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                          Checkbox(
                              value: isChecked1,
                              onChanged: (bool b) {
                                setState(() {
                                  isChecked1 = b;
                                });
                              }
                            ),
                            Text(
                              "I have been pregnant once or more"
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                                value: isChecked2,
                                onChanged: (bool b) {
                                  setState(() {
                                    isChecked2 = b;
                                  });
                                }
                            ),
                            Text(
                                "I was asymptomatic"
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                                value: isChecked3,
                                onChanged: (bool b) {
                                  setState(() {
                                    isChecked3 = b;
                                  });
                                }

                            ),
                            Text(
                                "I have Diabetes or Hypertension"
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                                value: isChecked4,
                                onChanged: (bool b) {
                                  setState(() {
                                    isChecked4 = b;
                                  });
                                }
                            ),
                            Text(
                                "I have chronic lung/kidney/liver/heart disease"
                            ),
                          ],
                        ),
                      ),

                      RaisedButton(
                        onPressed: () {
                          if(isChecked1 || isChecked2 || isChecked3 || isChecked4){
                            displayMessage();
                          }

                          else if (!formkey.currentState.validate()) return;
                          else {
                            formkey.currentState.save();
                            final Map<String, dynamic> DonorDetails = {
                              'bloodGroup': _selected,
                              'name': _name,
                              'covidPositiveDate': formattedDate,
                              'contactNumber': _contactNumber,
                              'age': _age,
                              'location': new GeoPoint(
                                  position.latitude, position.longitude),
                              'address': _address,
                            };
                            FirebaseFirestore.instance.collection('donors').add(
                                DonorDetails).then((result) {
                              dialogTrigger(context);
                            }).catchError((e) {
                              print(e);
                            });
                          }
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

  checkAge(int value){
    if(value<18 || value>65)
         return "Sorry, you cannot donate plasma";
    else return null;
  }
  checkWeight(int value){
    if(value<50)
      return "Sorry, you cannot donate plasma";
  }
  void displayMessage() {
    showDialog(context: context,
        builder: (BuildContext context) {
          AlertDialog dialog = AlertDialog(
            content: Text("Sorry! you are not eligible to donate plasma"),
            actions: [
              FlatButton(onPressed: () {
                Navigator.of(context).pop();
              },
                  child: Text("Okay")
              )
            ],
          );
          return dialog;
        });
  }
}
