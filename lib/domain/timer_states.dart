class TimerStates {
  TimerStates(this.type, this.sessions);

  factory TimerStates.fromEnergyType(EnergyType type) {
    List<TimerSession> states;

    switch (type) {
      case EnergyType.undefined:
        states = [];
      case EnergyType.veryLow:
      case EnergyType.low:
      case EnergyType.pomodoro:
      case EnergyType.high:
      case EnergyType.veryHigh:
        const int breakTimeRatio = 5;
        states = [
          TimerSession(
            type.duration,
            Duration(
              milliseconds: type.duration.inMilliseconds ~/ breakTimeRatio,
            ),
          ),
        ];
      case EnergyType.efficient:
        states = [
          TimerSession(
            const Duration(minutes: 45),
            const Duration(minutes: 5),
          ),
          TimerSession(
            const Duration(minutes: 45),
            const Duration(minutes: 20),
          ),
        ];
    }

    return TimerStates(type, states);
  }

  EnergyType type;
  List<TimerSession> sessions;

  int currentState = 0;

  TimerSession getCurrentSession() => sessions[currentState];

  void promoteSession() {
    if (currentState == sessions.length - 1) {
      currentState = 0;
      return;
    }
    currentState = currentState + 1;
  }
}

class TimerSession {
  TimerSession(this.study, this.breakDuration);

  Duration study;
  Duration breakDuration;
}

enum EnergyType {
  undefined(
    'undefined',
    Duration.zero,
  ),
  veryLow('very_low', Duration(minutes: 5)),
  low('low', Duration(minutes: 10)),
  pomodoro('Pomodoro', Duration(minutes: 25)),
  high('high', Duration(minutes: 45), tipsId: ['45m/5m']),
  veryHigh('very_high', Duration(minutes: 60)),
  efficient(
    'maximum_efficiency',
    Duration(minutes: 90),
    tipsId: ['45m/5m', '90m concentrated'],
  ),
  ;

  const EnergyType(
    this.previewName,
    this.duration, {
    this.tipsId,
  });

  final Duration duration;
  final String previewName;
  final List<String>? tipsId;
}
