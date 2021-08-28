import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class PublicMethods {
  static void snackMessage(
      {required final String message,
      required final BuildContext context,
      final bool isError = false}) {
    try {
      final SnackBar snackBar = SnackBar(
          duration: Duration(seconds: (isError) ? 4 : 2),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          behavior: SnackBarBehavior.floating,
          backgroundColor: (!isError) ? Colors.green[700] : Colors.red[900],
          content: Row(children: [
            Icon((!isError) ? Icons.done : Icons.error,
                size: 30, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
                child: Text(message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)))
          ]));
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<String> getErrorFromServer(
      {required final http.Response response,
      required final BuildContext context}) async {
    try {
      if (response.statusCode == 404) {
        return "No hay datos (${response.statusCode})";
      }
      if (response.statusCode >= 500 && response.statusCode < 600) {
        return "Error interno del servidor (${response.statusCode})";
      }
      var errorJSON = await json.decode(utf8.decode(response.bodyBytes));
      switch (errorJSON.runtimeType.toString()) {
        case "_InternalLinkedHashMap<String, dynamic>":
          if ((errorJSON as Map<String, dynamic>).containsKey("detail")) {
            return "${errorJSON['detail']} Error: ${response.statusCode}";
          }
          return "${_getListServerErrors(errorJSON)}Error: ${response.statusCode}";
        case "List<dynamic>":
          List<dynamic> _errorsList =
              await json.decode(utf8.decode(response.bodyBytes));
          return "${_errorsList.join('\n')} Error: ${response.statusCode}";
        case "JSArray<dynamic>":
          List<dynamic> _errorsList =
              await json.decode(utf8.decode(response.bodyBytes));
          return "${_errorsList.join('\n')} Error: ${response.statusCode}";
        default:
          return "${(errorJSON).toString()} Error: ${response.statusCode}";
      }
    } catch (error) {
      return error.toString();
    }
  }

  static String _getListServerErrors(final Map<String, dynamic> errors) {
    try {
      String error = "";
      for (var key in errors.keys) {
        error += "$key: ${errors[key]}\n";
      }
      return error;
    } catch (error) {
      throw error.toString();
    }
  }
}
