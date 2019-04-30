import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:firebase_web/firebase.dart' as fb;
import 'package:analytics_web/app_component.template.dart' as ng;

import 'package:analytics_web/assets/assets.dart';
import 'main.template.dart' as self;

@GenerateInjector([
  routerProvidersHash,
])
final InjectorFactory injector = self.injector$Injector;

void main() async {
  final env = const String.fromEnvironment('env');
  print('env is $env');

  if (env != null)
    await config(env);
  else
    await config('dev');

  try {
    fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseUrl,
        storageBucket: storageBucket,
        projectId: projectId);

    runApp(ng.AppComponentNgFactory, createInjector: injector);
  } on fb.FirebaseJsNotLoadedException catch (e) {
    print(e);
  }
}
