import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

class LoginMechanism {
  static const String email = 'EMAIL';
  static const String fingerprint = 'FINGERPRINT';
  static const String face = 'FACE';
  static const String pin = 'PIN';
}

class Preference {
  static const String isFirstRun = 'isFirstRun';
  static const String isLangAR = 'LOGIN_MECHANISM';
  static const String isLogin = 'ONBOARDING_COMPLETE';
  static const String activeCallChannel = 'ACTIVE_CALL_CHANNEL';

  // One-time question: user asked if they want to use a PIN for authentication
  static const String loginMechanismPinAsk = 'LOGIN_MECHANISM_PIN_ASK';

  // Flag indicating if fingerprint authentication is supported
  static const String credentialsFingerprintAvailable =
      'CREDENTIALS_FINGERPRINT_AVAILABLE';

  static const String credentialsFaceAvailable = 'CREDENTIALS_FACE_AVAILABLE';

  static const String number = 'USERS_FIRST_NAME';

  static const String isWelcomeScreenSeen = 'IS_WELCOME_SCREEN_SEEN';

  static const String profilePictureUrl = 'INVALID_PIN_COUNT';

  static const String pin = 'PIN';

  static const String accessToken = 'ACCESS_TOKEN';
  static const String oldAccessToken = 'OLD_ACCESS_TOKEN';
  static const String isCallRinging = 'IS_CALL_RINGING';
  static const String isOnCall = 'IS_ON_CALL';

  static const String refreshToken = 'REFRESH_TOKEN';

  static const String userID = 'USER_ID';

  static const String userData = 'USER_DATA';
  static const String userFirebaseID = 'userFirebaseID';
  static const String userFullName = 'userFullName';
  static const String currentWorkspaceToken = 'CURRENT_WORKSPACE_SECRET_KEY';
  static const String selectedContactId = 'SELECTED_CONTACT';
  static const String twilioAcessToken = 'Twilio_Token';

  static const String callerName = 'CALLER_NAME';
  static const String callerNumber = 'CALLER_NUMBER';
}

@injectable
class Preferences {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  saveCallerName(String name) async {
    await _secureStorage.write(key: Preference.callerName, value: name);
  }

  Future<String> getCallerName() async {
    return await _secureStorage.read(key: Preference.callerName) ?? '';
  }

  saveCallerNumber(String number) async {
    await _secureStorage.write(key: Preference.callerNumber, value: number);
  }

  Future<String> getCallerNumber() async {
    return await _secureStorage.read(key: Preference.callerNumber) ?? '';
  }

  Future saveString(String name, String value) async {
    await _secureStorage.write(key: name.toLowerCase(), value: value);
  }

  Future saveModel(String name, Object value) async {
    await _secureStorage.write(
        key: name.toLowerCase(), value: value.toString());
  }

  Future userData(String name, String value) async {
    await _secureStorage.write(key: name.toLowerCase(), value: value);
  }

  Future saveBool(String name, bool value) async {
    await _secureStorage.write(
        key: name.toLowerCase(), value: value.toString());
  }

  Future saveLOGOUT() async {
    await _secureStorage.deleteAll();
  }

  Future<String?> getString(String name) async {
    return await _secureStorage.read(key: name.toLowerCase());
  }

  Future<bool> getBool(String name) async {
    final value = await _secureStorage.read(key: name.toLowerCase());
    return value == 'true';
  }

  Future<int> getInt(String name) async {
    final value = await _secureStorage.read(key: name.toLowerCase());
    var intValue = value ?? '0';
    return int.parse(intValue);
  }

  Future saveInt(String name, int value) async {
    await _secureStorage.write(
        key: name.toLowerCase(), value: value.toString());
  }

  Future remove(String name) async {
    await _secureStorage.delete(key: name.toLowerCase());
  }

  Future removeAll() async {
    await _secureStorage.deleteAll();
  }
}
