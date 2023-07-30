import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:work_out/core/injection/dependency_injection.config.dart';

final sl = GetIt.instance;
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() => sl.init();

@module
abstract class GetModule {
  @preResolve
  Future<FlutterSecureStorage> get prefs async => const FlutterSecureStorage();
  @postConstruct
  Dio get connectivity => Dio();
}
