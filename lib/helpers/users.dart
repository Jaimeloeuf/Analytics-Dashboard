import 'dart:async';
import 'package:firebase_web/firebase.dart' as fb;

/*@Doc
  Package contains functions that interfaces with the cloud functions.

  The user data will be maintained and updated automatically by the UserData class, whereas
  to keep the view updated, the view either needs to poll the UserData or maintain a stream.

  Difference between BLoCs and Services.
  Difference is that BLoCs provide streams, which the view Component implements it properties to listen to those streams
  However for Services, its like an object, where you need to constantly poll it for data.
*/

class UserDataBloc {
  // Static const reference to the singleton object of UserData created using named constructor "_internal".
  static final UserDataBloc _singleton = new UserDataBloc._internal();

  StreamController _streamController = new StreamController();
  Stream get userDataStream => _streamController.stream;

  // Internal constructor used to create the singleton
  UserDataBloc._internal() {
    // Run the method to set the User Data into the "cache" for the first time
    get_data();

    // Run a function to constantly update the "cached" data
    Timer.periodic(Duration(minutes: 30), (Timer) => get_data());
    // The timer below is a repeating one at 6s which is used only for testing
    // Timer.periodic(Duration(seconds: 6), (Timer) => get_data());
  }

  // Factory constructor method returning the singleton object
  factory UserDataBloc() {
    return _singleton;
  }

  // The user data is stored in memory and automatically updated at intervals
  Map<String, dynamic> _userData;

  // firebase functions that the other methods can use to call CFs.
  final fb.Functions functions = fb.functions();

  void get_data() {
    functions.httpsCallable('queryUserData').call(null).then((callableResult) {
      // Extract the data out from the response
      Map<String, dynamic> resultData = callableResult.data;

      // Debug to view all data returned by the cloud function
      print(callableResult.data);

      // If the return value is empty for whatever reasons
      if (resultData == null) {
        // Sink error via base bloc instead
        print('function httpscallable failed');
        return null;
      }

      // Check the response field if cloud function execution failed in anyway
      if (!resultData['is_success']) {
        print('Cloud function failed execution internally');
        return null;
      }

      // If the data changed
      if (resultData != _userData) {
        // Write to the object property that acts as the data cache
        _userData = resultData;
        // Stream the new data to subscribers
        _streamController.add(resultData);
      }
    });
  }
}

Future queryUserData() async {
  fb.Functions functions = fb.functions();
  return functions
      .httpsCallable('queryUserData')
      .call(null)
      .then((callableResult) {
    // Extract the data out from the response
    Map<String, dynamic> resultData = callableResult.data;

    // Debug to view all data returned by the cloud function
    print(callableResult.data);

    // If the return value is empty for whatever reasons
    if (resultData == null) {
      print('function httpscallable failed');
      return null;
    }

    // Check the response field if cloud function execution failed in anyway
    if (!resultData['is_success']) {
      print('Cloud function failed execution internally');
      return null;
    }

    // Return result if everything OK
    return resultData;
  });
}

// Future<int> getUsersCount() async {
//   // Map<String, dynamic> resultData = await queryUserData();
//   // Below method supports "real-time" data
//   Map<String, dynamic> resultData = UserDataBloc().data();
//   print('user count: ${resultData['user_count']}');
//   return resultData['user_count'];
// }
