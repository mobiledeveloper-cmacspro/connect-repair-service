import 'package:repairservices/models/Windows.dart';

abstract class IPDFManager{
  Future<String> getPDf(Fitting fitting);
}

