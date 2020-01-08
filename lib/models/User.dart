import 'package:flutter/cupertino.dart';

class User {
  static User current;

  String gender,hybrisId,country,zip,email,supplierNumber,salutation,allgroups,firstName,lastName,city,customerNumber,
      type,targetgroup,usergroups,cmsId,cpsUserId,street,activeB2BUnit;
  List<B2bUnit> b2BUnits = [];
  bool active,isInternalUser,registrationPending;

  User(this.gender,this.hybrisId,this.country,this.zip,this.email,this.supplierNumber,this.salutation,this.allgroups,this.firstName,this.lastName,
    this.city,this.customerNumber,this.type,this.targetgroup,this.usergroups,this.cmsId,this.cpsUserId,this.street,this.activeB2BUnit,this.active,
    this.isInternalUser,this.registrationPending);

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      json['gender'],
      json['hybrisId'],
      json['country'],
      json['zip'],
      json['email'],
      json['supplierNumber'],
      json['salutation'],
      json['allgroups'],
      json['firstName'],
      json['lastName'],
      json['city'],
      json['customerNumber'],
      json['type'],
      json['targetgroup'],
      json['usergroups'],
      json['cmsId'],
      json['cpsUserId'],
      json['street'],
      json['activeB2BUnit'],
      json['active'] == "true" ? true : false,
      json['isInternalUser'] == "true" ? true : false,
      json['registrationPending'] == "true" ? true : false
    );
    for(Map<String, dynamic> b2bUnit in json['b2BUnits']) {
      final b2bUnitObject = B2bUnit.fromJson(b2bUnit);
      debugPrint(b2bUnitObject.name + " seePrice: " + b2bUnitObject.seePrices.toString());
      user.b2BUnits.add(b2bUnitObject);
    }
    return user;
  }
}

class B2bUnit {
  static B2bUnit current;
  bool canBuy,seePrices;
  String id,name;
  B2bUnit(this.canBuy,this.seePrices,this.id,this.name);
  factory B2bUnit.fromJson(Map<String, dynamic> json) {
    B2bUnit b2bUnit = B2bUnit(
        json['canBuy'] == "true" ? true : false,
        json['seePrices'] == "true" ? true : false,
        json['id'],
        json['name']);
    return b2bUnit;
  }
}