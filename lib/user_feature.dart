/// This class is optional to set the user features on video ads. [Usage](https://github.com/fan-ADN/nendSDK-Flutter/wiki/Implementation-for-video-ads#set-up-features-of-user).
class UserFeature {
  Gender gender = Gender.unknown;
  int age = -1;

  Map<String, int> _birthday;
  Map<String, int> get birthday => _birthday;
  void setBirthday(int year, int month, int day) {
    _birthday = {'year': year, 'month': month, 'day': day};
  }

  Map<String, String> customStringParams = Map<String, String>();
  Map<String, int> customIntegerParams = Map<String, int>();
  Map<String, double> customDoubleParams = Map<String, double>();
  Map<String, bool> customBooleanParams = Map<String, bool>();
}

enum Gender { unknown, male, female }
