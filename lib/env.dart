enum Env{production,staging,local}

class ENV{
  static final ENV _singleton = ENV._internal();
  factory ENV() => _singleton;
  ENV._internal();

  Env currentEnv = Env.staging;
}