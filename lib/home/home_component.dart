import 'package:angular/angular.dart';

// Imports for all the components
import 'package:analytics_web/TotalUsers/total_users_component.dart';
import 'package:analytics_web/NewUsers/new_users_component.dart';

@Component(
    selector: 'home',
    styleUrls: ['home_component.css'],
    templateUrl: 'home_component.html',
    directives: [NgFor, NgIf, TotalUsersComponent, NewUsersComponent])
class HomeComponent implements OnInit {
  @override
  ngOnInit() {}
}
