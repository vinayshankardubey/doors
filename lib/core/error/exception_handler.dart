import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<T?> exceptionHandler<T> (Future<T> Function() task) async{
  try {
    return await task();
  } on SocketException {
    debugPrint("No Internet connection.");
  } on TimeoutException {
    debugPrint("Request timed out.");
  } on AuthException catch (e) {
    debugPrint("Authentication error: ${e.message}");
  } on PostgrestException catch (e) {
    debugPrint("Supabase DB error: ${e.message}");
  } on FormatException {
    debugPrint("Invalid format");
  } catch (e) {
    debugPrint("Unexpected exception occurred: $e");
  }
  return null;
}
