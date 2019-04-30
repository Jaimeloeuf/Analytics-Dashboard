import 'package:angular/angular.dart';

import 'package:analytics_web/helpers/users.dart';

@Component(
    selector: 'new-users',
    templateUrl: 'new_users_component.html',
    styleUrls: ['new_users_component.css'])
class NewUsersComponent implements OnInit {
  int newUsers = 0;

  @override
  ngOnInit() async {
    // Get all data from helper functions to populate the Component Properties
    // Timer.periodic(Duration(seconds: 6), (Timer) async {
    // newUsers = await getUsersCount();
    // });

    // setInterval(3, () async => totalUsers = await getUsersCount());
  }
}
