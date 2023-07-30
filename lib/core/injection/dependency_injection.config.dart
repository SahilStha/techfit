// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../preferences.dart' as _i5;
import '../../providers/api_client.dart' as _i6;
import '../../view/screens/customworkout/bloc/custom_workout_bloc.dart' as _i7;
import '../../view/screens/customworkout/bloc/excersice_bloc.dart' as _i9;
import '../../view/screens/dietscreen/bloc/diet_bloc.dart' as _i8;
import 'dependency_injection.dart' as _i10;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final getModule = _$GetModule();
    gh.factory<_i3.Dio>(() => getModule.connectivity);
    await gh.factoryAsync<_i4.FlutterSecureStorage>(
      () => getModule.prefs,
      preResolve: true,
    );
    gh.factory<_i5.Preferences>(() => _i5.Preferences());
    gh.factory<_i6.ApiClient>(() => _i6.ApiClient(
          gh<_i3.Dio>(),
          gh<_i5.Preferences>(),
        ));
    gh.factory<_i7.CustomWorkoutBloc>(
        () => _i7.CustomWorkoutBloc(gh<_i6.ApiClient>()));
    gh.factory<_i8.DietBloc>(() => _i8.DietBloc(gh<_i6.ApiClient>()));
    gh.factory<_i9.ExcersiceBloc>(() => _i9.ExcersiceBloc(gh<_i6.ApiClient>()));
    return this;
  }
}

class _$GetModule extends _i10.GetModule {}
