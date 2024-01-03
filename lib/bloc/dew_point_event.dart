sealed class DewPointEvent {
  const DewPointEvent();
}

final class DewPointInitial extends DewPointEvent {
  const DewPointInitial();
}

final class DewPointNewData extends DewPointEvent {
  const DewPointNewData();
}

final class DewPointError extends DewPointEvent {
  const DewPointError();
}
