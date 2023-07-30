class Endpoints {
  static const String baseUrl = 'http://194.163.170.129:8088/api';
  static const String workouts = '/workouts/';
  static const String diets = '/diets/';
  static const String exercises = '/exercises/';
  static const String heatLevel = '/heat-level/user/';
  static const String getVideos = '/video-files/all';
  static String deteleWorkout(String workoutId) => '/workouts/$workoutId';
  static String excersiseWithId(String excersiseId) =>
      '/exercises/$excersiseId';
  static String deleteDiet(String dietId) => '/diets/$dietId';
  static String checkUncheckDiet(String dietId) => '/diets/check/$dietId';
}
