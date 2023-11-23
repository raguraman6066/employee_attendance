import 'package:employee_attendance/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/utils.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DbService dbService = DbService();
  bool _isLoading = false;
  bool get isLoading => _isLoading; //return isloading value
  set setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future registerEmployee(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      setIsLoading = true;
      if (email == '' || password == '') {
        throw ('All fields are required');
      }
      final AuthResponse response =
          await _supabase.auth.signUp(email: email, password: password);
      if (response != null) {
        await dbService.insertNewUser(email, response.user?.id);
        Utils.showSnackBar(
          message: 'Successfully registered !',
          context: context,
          color: Colors.green,
        );
        await loginEmployee(email: email, password: password, context: context);
        Navigator.pop(context);
      }
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(
          message: e.toString(), context: context, color: Colors.red);
    }
  }

  Future loginEmployee(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      setIsLoading = true;
      if (email == '' || password == '') {
        throw ('All fields are required');
      }
      final AuthResponse response = await _supabase.auth
          .signInWithPassword(email: email, password: password);

      setIsLoading = false;
    } catch (e) {
      setIsLoading = false;
      Utils.showSnackBar(
          message: e.toString(), context: context, color: Colors.red);
    }
  }

  Future signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
