import 'package:flutter/cupertino.dart';

class Donor {
  String name;
  String age;
  String covidPositiveDate;
  String bloodGroup;
  String contactNumber;

  Donor({
    this.name,
    this.age,
    this.covidPositiveDate,
    this.bloodGroup,
    this.contactNumber,
  });

  factory Donor.fromJson(Map<String, dynamic> json){
    return Donor(
      name: json['name'],
      age: json['age'],
      covidPositiveDate: json['covidPositiveDate'],
      bloodGroup: json['bloodGroup'],
      contactNumber: json['contactNumber'],
    );
  }

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'age':age,
      'covidPositiveDate':covidPositiveDate,
      'bloodGroup':bloodGroup,
      'contactNumber':contactNumber,
    };
  }
}


