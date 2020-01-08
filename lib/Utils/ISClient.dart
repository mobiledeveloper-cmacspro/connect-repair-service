import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:repairservices/models/Company.dart';
//import 'package:flutter/cupertino.dart' as prefix0;
import 'package:repairservices/models/Product.dart';
import 'package:repairservices/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class ISClientO {


  ISClientO._privateConstructor();

  static final instance = ISClientO._privateConstructor();

  static String _baseUrl;
  Dio dio = new Dio();

  Future<bool> isTokenAvailable() async {
    final prefs = await SharedPreferences.getInstance();

    final ssStr = prefs.getString("expires_in");
    final dateTokenStr = prefs.getString("dateToken");
    if (ssStr != null && dateTokenStr != null) {
      final ss = int.parse(ssStr);
      final dateToken = DateTime.parse(dateTokenStr);
      debugPrint("dateToken: " + dateToken.toString() + ", Date Now: " + DateTime.now().toString());
      final expireDate = dateToken.add(Duration(seconds: ss));
      debugPrint("Expire Date: " + expireDate.toString());
      debugPrint("Expire Date is after of Now: " + expireDate.isAfter(DateTime.now()).toString());

      if (expireDate.isAfter(DateTime.now())) {
        return true;
      }
      else {
        return false;
      }
    }
    return false;
  }

  Future<String> get baseUrl async {

    if(_baseUrl != null && _baseUrl != "") return _baseUrl;
    final prefs = await SharedPreferences.getInstance();
    final key = 'base_url';
    _baseUrl = prefs.getString(key) ?? 'https://connecttest.schueco.com';
    return _baseUrl;
  }

  Future<List<String>> getProductNumberAutocompletion (String number) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = await baseUrl + "/schuecocommercewebservices/v2/schuecobcp/externService/user/" + number;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final js = json.decode(response.body);
      final result = js['results'] as String;
      final list = result.split(',');
      list.removeLast();
      return list;
    }
    else {
      throw Exception('Failed to load Articles');
    }
  }

  Future<Product> getProductDetails(String number, int quantity) async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    final prefs = await SharedPreferences.getInstance();
    final key = 'qrcode';
    bool qrCodeScan = prefs.getBool(key) ?? false;
    final loggued = await this.isTokenAvailable();
    String url = await baseUrl + "/schuecocommercewebservices/v2/schuecobcp/externService/user/getProductDetailsForNotLoggedInUser";
    final b2bUnit = loggued ? prefs.getString("b2bUnitId")  : "1844_0001_KU";

    Map<String,dynamic> data = {
      "language": "EN",
      "b2bUnit": b2bUnit,
      "products": {"articleNr": number}
    };

    Map<String, dynamic> header = { "Content-Type":"application/json"};

    if (loggued) {
      url = await baseUrl + "/schuecocommercewebservices/v2/schuecobcp/externService/user/getProductDetailsForLoggedInUser";
      debugPrint(url);
      header = {
        "Content-Type": "application/json",
        "Authorization": "bearer" + prefs.getString("access_token")
      };
      debugPrint(header.toString());
      final date = DateTime.now().add(Duration(days: 14));
      final deliveryDate = DateFormat('dd.MM.yyyy').format(date);
      debugPrint(deliveryDate);
      data = {
        "language": "EN",
        "b2bUnit": "1844_0001_KU",
        "products": {
          "articleNr": number,
          "deliveryDate" : deliveryDate,
          "unit":"ST",
          "quantity": quantity != null ? quantity.toString() : "1"
        }
      };
    }
    debugPrint(data.toString());
    final response = await dio.put(
      url,
      options: Options(headers: header),
      data: data
    );
    if (response.statusCode == 200) {
      final js = response.data;
      debugPrint("Product Details Response $js");
      if (js != null && js['errors'] != null) {
        throw Exception(js["error_description"].toString());
      }
      else if (js["products"] != null && js["products"].toString().contains("error")) {
          if (qrCodeScan) {
            throw 'No Schuco article';
          }
          else {
            throw 'The details of this product can not be displayed at this time';
          }
      }
      return Product.fromJson(js);
    }
    else {
      throw 'Failed to load Article Details';
    }
  }

  Future<void> clearToken() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("access_token");
    prefs.remove("expires_in");
    prefs.remove("dateToken");
  }

  Future<bool> loginUser(String username, String password) async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    final url = await baseUrl + "/authorizationserver/oauth/token";
    debugPrint('Login with url: $url with username: $username and password: $password');

    Map <String, String> body = {
      'username':username,
      'password': password,
      'grant_type':'password',
      'client_id': 'mobile',
      'client_secret': 'flaxeh04'
    };

    final response = await dio.post(
        url,
        data: body,
        options: Options(contentType:Headers.formUrlEncodedContentType )
    );
    debugPrint('StatusCode: ${response.statusCode}');
    if (response.statusCode == 401) {
      throw 'Bad credentials';
    }
    else if (response.statusCode == 200){
      final js = response.data;
      debugPrint("Login Response $js");
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("access_token", js["access_token"].toString());
      prefs.setString("expires_in", js["expires_in"].toString());
      prefs.setString("dateToken", DateTime.now().toString());
      return true;
    }
    else {
      debugPrint(response.data);
      debugPrint('StatusCode: ${response.statusCode}');
      throw 'Failed to Login';
    }
  }

  Future<bool> getUserInformation() async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    final url = await baseUrl + "/schuecocommercewebservices/v2/schuecobcp/externService/user/mobileLogin/current";
    final prefs = await SharedPreferences.getInstance();

    final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "bearer" + prefs.getString("access_token")})
    );
    if (response.statusCode == 200) {
      final js = response.data;
      debugPrint("User Information Response: $js");
      debugPrint('active: ${js['active'].toString()}');

        prefs.setString('hybrisId', js['hybrisId'].toString());
        User.current = User.fromJson(js);
        debugPrint(User.current.firstName);
        return true;
    }
    else {
      throw 'Failed to load User Information';
    }
  }

  Future<bool> createCart(String cardName, List<Product> producList) async {
    debugPrint('Create cart from ISCLient');
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("hybrisId");
    final b2bUnit = prefs.getString("b2bUnitId") != null ? prefs.getString(
        "b2bUnitId") : "1844_0001_KU";
    var serializeProducts = [];

    for (Product product in producList) {
      final productJs = {
        "articleNr": product.number.value,
        "quantity": {"value": product.quantity.value, "type": "ST"}
      };
      serializeProducts.add(productJs);
    }
    final data = {
      "user": user,
      "cardname": cardName,
      "note": "test",
      "b2bUnit": b2bUnit,
      "products": serializeProducts
    };
    final dataEncode = jsonEncode(data);
    debugPrint('dataEncode: $dataEncode');
    final header = {
      "Content-Type": "application/json",
      "Authorization": "bearer" + prefs.getString("access_token")
    };
    debugPrint('dataEncode: $header');

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = await baseUrl +
        "/schuecocommercewebservices/v2/schuecobcp/externService/user/cartCreateSet";
    final response = await http.post(url, headers: header,body: dataEncode);

    debugPrint('${response.statusCode}');
    final js = json.decode(response.body);
    debugPrint('js: $js');
    if (response.statusCode == 200) {

      debugPrint(js);
      return true;
    }
    else {
      return false;
//      debugPrint('Failed to create cart');
//      throw Exception('Failed to create cart');
    }
  }

  Future<bool> saveAddress(String companyName,street,number,city,postCode,country) async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    final prefs = await SharedPreferences.getInstance();
    final b2bUnit = prefs.getString("b2bUnitId") != null ? prefs.getString("b2bUnitId") : "1844_0001_KU";
    final url = await baseUrl + "/schuecocommercewebservices/v2/schuecobcp/externService/user/saveAddress";
    final header = {
      "Content-Type": "application/json",
      "Authorization": "bearer" + prefs.getString("access_token")
    };
    final body = {
      "b2bUnit" : b2bUnit,
      "name" : companyName,
      "street" : street,
      "nr" : number,
      "city" : city,
      "postCode" : postCode,
      "country" : country
    };

    final response = await dio.post(
        url,
        data: body,
        options: Options(headers: header)
    );
    debugPrint('StatusCode: ${response.statusCode}');
    if (response.statusCode == 200){
      final js = response.data;
      debugPrint("Login Response $js");
      return true;
    }
    else {
      throw 'Failed to save address';
    }
  }

  Future<bool> saveOrder(bool express, String note, Address address, List<Product> producList) async {
    debugPrint('Save Order from ISCLient');
    final prefs = await SharedPreferences.getInstance();
    final b2bUnit = prefs.getString("b2bUnitId") != null ? prefs.getString(
        "b2bUnitId") : "1844_0001_KU";
    var serializeProducts = [];

    for (Product product in producList) {
      final productJs = {
        "articleNr": product.number.value,
        "quantity": {"value": product.quantity.value, "type": "ST"}
      };
      serializeProducts.add(productJs);
    }
    final date = DateTime.now().add(Duration(days: 14));
    final deliveryDate = DateFormat('dd.MM.yyyy').format(date);
    final data = {
      "sessionLanguage":'EN',
      "avaibilityDate": deliveryDate,
      "express": true,
      "note": note,
      "Seltectetaddress" : {
        "name":address.companyName,
        "street": address.street,
        "Nr": address.houseNumber,
        "postcode":address.postCode,
        "city":address.city,
        "country":address.country
      },
      "note": "test",
      "b2bUnit": b2bUnit,
      "products": serializeProducts
    };
    final dataEncode = jsonEncode(data);
    debugPrint('dataEncode: $dataEncode');
    final header = {
      "Content-Type": "application/json",
      "Authorization": "bearer" + prefs.getString("access_token")
    };
    debugPrint('dataEncode: $header');

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = await baseUrl +
        "/schuecocommercewebservices/v2/schuecobcp/externService/user/cartCreateSet";
    final response = await http.post(url, headers: header,body: dataEncode);

    debugPrint('${response.statusCode}');
    final js = json.decode(response.body);
    debugPrint('js: $js');
    if (response.statusCode == 200) {

      debugPrint(js);
      return true;
    }
    else {
      return false;
//      debugPrint('Failed to create cart');
//      throw Exception('Failed to create cart');
    }
  }

}
