import 'dart:async';
import 'validators.dart';
import 'package:rxdart/rxdart.dart';

class Bloc with Validators {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool?> get submitValid =>
      Rx.combineLatest2(email, password, _validate);

  // Change data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  // Control if validation not have error.
  bool? _validate(String e, String p) {
    // We only need to return the required value.
    // Return true if we have the required value otherwise null
    // to tell StreamBuilder that we have no data here.
    // If you return false, not null, StreamBuilder will think it has data.
    // In this way snapshot.hasData will work properly.
    return e == _email.value && p == _password.value ? true : null;
  }

  submit() {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print('Email is $validEmail');
    print('Password is $validPassword');
  }

  dispose() {
    _email.close();
    _password.close();
  }
}
