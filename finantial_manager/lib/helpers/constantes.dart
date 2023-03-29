import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

Dio dio = Dio();

const urlAPI = 'https://10.0.2.2:44380';

final formatFromJson = DateFormat('yyyy-MM-ddThh:mm:ss');

String errorMessage = "";
