import 'dart:async';
import 'package:angular/angular.dart';
import 'package:analytics_web/helpers/users.dart';

@Component(
    selector: 'total-users',
    templateUrl: 'total_users_component.html',
    styleUrls: ['total_users_component.css'],
    providers: [ClassProvider(UserDataBloc)])
class TotalUsersComponent implements OnInit, OnDestroy {
  TotalUsersComponent(this._userDataBloc);

  final UserDataBloc _userDataBloc;
  StreamSubscription _userDataStream;


  int totalUsers = 0;

  // Below increasedBy values will be tied to streams from the increased_by_bloc
  double increasedBy_month = 3.48;
  double increasedBy_week = 1.34;
  double increasedBy_day = 2.98;


  @override
  ngOnInit() async {
    // Setup all the data stream subscriptions
    _userDataStream = _userDataBloc.userDataStream.listen((data) {
      print('user count: ${data['user_count']}');
      totalUsers = data['user_count'];
    });
  }

  @override
  void ngOnDestroy() {
    // Cancel all stream subscriptions before component is destroyed to prevent memory leaks
    _userDataStream?.cancel();
  }
}
