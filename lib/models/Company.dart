// database table and column names
import 'dart:convert';

import 'dart:io';

final String tableCompany = 'company';
final String columnCompanyId = '_id';
final String columnCompanyName = 'name';
final String columnAdditionalInf = 'additionalInf';
final String columnPhone = 'phone';
final String columnEmail = 'email';
final String columnFax = 'fax';
final String columnWebsite = 'website';
final String columnLogoPath = 'logoPath';
final String columnStreet = 'street';
final String columnHouseNumber = 'houseNumber';
final String columnExtraAddressLine = 'extraAddressLine';
final String columnPostCode = 'postCode';
final String columnLocation = 'location';
final String columnLat = 'lat';
final String columnLng = 'lng';
final String columnTextExportEmail = 'textExportEmail';
final String columnDefaultC = 'defaultC';

// data model class
class Company {
  int id;
  String name;
  String additionalInf;
  String phone;
  String email;
  String fax;
  String website;
  String logoPath;
  String textExportEmail;
  bool defaultC;
  Address address = Address();
  static Company currentCompany;
  Company();

  // convenience constructor to create a Word object
  Company.fromMap(Map<String, dynamic> map) {
    id = map[columnCompanyId];
    name = map[columnCompanyName];
    additionalInf = map[columnAdditionalInf];
    phone = map[columnPhone];
    email = map[columnEmail];
    fax = map[columnFax];
    website = map[columnWebsite];
    logoPath = map[columnLogoPath];

    address = Address.withData(
        map[columnStreet],
        map[columnHouseNumber],
        map[columnExtraAddressLine],
        map[columnPostCode],
        map[columnLat],
        map[columnLng],
        map[columnLocation]);
    textExportEmail = map[columnTextExportEmail];
    defaultC = map[columnDefaultC] == 0 ? false : true;
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCompanyName: name,
      columnAdditionalInf: additionalInf,
      columnPhone: phone,
      columnEmail: email,
      columnFax: fax,
      columnWebsite: website,
      columnLogoPath: logoPath,
      columnStreet: address.street,
      columnHouseNumber: address.houseNumber,
      columnExtraAddressLine: address.extraAddressLine,
      columnPostCode: address.postCode,
      columnLat: address.lat,
      columnLng: address.lng,
      columnTextExportEmail: textExportEmail,
      columnLocation: address.location,
      columnDefaultC: defaultC == true ? 1 : 0
    };
    if (id != null) {
      map[columnCompanyId] = id;
    }
    return map;
  }
  String htmlLayoutPreview(){
    String str = '<tr class="information"><td colspan="2" style="padding-bottom: 0px;"><h4 style="color: #c5571f;">Company profile:</h4></td></tr>'
        '<td><h4>#COMPANYNAME#</h4></td><td class="title"> <img src="#LOGO#" style="width:70%; max-width:70px;"></td><tr class="details">'
        '<td> #ADITIONALINFORMATION# </td></tr><tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">'
        'Phone number:</a> #PHONE# </td></tr><tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Email:'
        '</a> #EMAIL# </td></tr><tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Fax</a> #FAX# </td></tr>'
        '<tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Webite:</a> #WEBSITE# </td></tr><tr class="detailsc">'
        '<td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Address:</a> #ADDRESS# </td></tr><tr class="detailsc">'
        '<td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Company Text:</a> #TEXTEXPORTEMAIL# </td></tr>';
    if(this.logoPath != null && this.logoPath != ''){
      String logo64 = base64Encode(File(logoPath).readAsBytesSync());
      str = str.replaceAll("#LOGO#",'data:image/png;base64,$logo64');
    }
    else {
      str = str.replaceAll('\\<td class="title"> <img src="#LOGO#" style="width:70%; max-width:70px;"></td>', '');
    }
    str = str.replaceAll('#COMPANYNAME#', name);
    if(additionalInf != null && additionalInf != ''){
      str = str.replaceAll('#ADITIONALINFORMATION#', additionalInf);
    }
    else {
      str = str.replaceAll('\\<tr class="details"><td> #ADITIONALINFORMATION# </td></tr>', '');
    }
    if(phone!=null && phone !=''){
      str = str.replaceAll('#PHONE#', phone);
    }
    else {
      str = str.replaceAll('\\<tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Phone number:</a> #PHONE# </td></tr>', '');
    }
    if(email!=null && email != ''){
      str = str.replaceAll('#EMAIL#', email);
    }
    else {
      str = str.replaceAll('\\<tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Email:</a> #EMAIL# </td></tr>', '');
    }
    if(fax != null && fax != ''){
      str = str.replaceAll('#FAX#', fax);
    }
    else {
      str = str.replaceAll('\\<tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Fax</a> #FAX# </td></tr>', '');
    }
    if(website != null && website !=''){
      str = str.replaceAll('#WEBSITE#', website);
    }
    else {
      str = str.replaceAll('\\<tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Webite:</a> #WEBSITE# </td></tr>', '');
    }
    if(address != null){
      str = str.replaceAll('#ADDRESS#', address.completeAddress());
    }
    else {
      str = str.replaceAll('\\<tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Address:</a> #ADDRESS# </td></tr>', '');
    }
    if(textExportEmail != null && textExportEmail !=''){
      str = str.replaceAll('#TEXTEXPORTEMAIL#', textExportEmail);
    }
    else {
      str = str.replaceAll('\\<tr class="detailsc"><td style="padding-bottom: 0px;"> <a style="font-weight:bold;">Company Text:</a> #TEXTEXPORTEMAIL# </td></tr>', '');
    }
    return str;
  }
}

class Address {
  String street;
  int houseNumber;
  String extraAddressLine;
  int postCode;
  double lat;
  double lng;
  String location;
  String companyName,city,country;

  Address();
  Address.withData(street,houseNumber,extraAddressLine,postCode,lat,lng,location) {
    this.street = street;
    this.houseNumber = houseNumber;
    this.extraAddressLine = extraAddressLine;
    this.postCode = postCode;
    this.lat = lat;
    this.lng = lng;
    this.location = location;
  }
  Address.forOrder(companyName,street,houseNumber,city,postCode,country){
    this.companyName = companyName;
    this.street = street;
    this.houseNumber = houseNumber;
    this.city = city;
    this.postCode = postCode;
    this.country = country;
  }
  String completeAddress(){
    var address = List<String>();

    if (street != null && street != ""){
      address.add(street);
    }
    if (houseNumber != null) {
      if (address.length > 0) {
        address.add(" $houseNumber");
      }
      else {
        address.add("$houseNumber");
      }
    }
    if (extraAddressLine != null && extraAddressLine != "") {
      if (address.length > 0) {
        address.add(", $extraAddressLine");
      }
      else {
        address.add("$extraAddressLine");
      }
    }
    if (postCode != null) {
      if (address.length > 0) {
        address.add(", $postCode");
      }
      else {
        address.add("$postCode");
      }
    }
    if (location != null && location != "") {
      if (address.length > 0) {
        address.add(", $location");
      }
    }
    String completeAddressStr = "";
    for(String text in address) {
      completeAddressStr += text;
    }
    return completeAddressStr;
  }
}