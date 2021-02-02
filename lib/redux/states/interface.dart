

class InterfaceState {

  bool busy;

  InterfaceState({
    busy
  }) {
    this.busy = busy;
  }

  InterfaceState copy({ bool busy }) {
    return InterfaceState(busy: busy ?? this.busy);
  }

  static InterfaceState initialState() => InterfaceState(busy: false);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is InterfaceState &&
      runtimeType == other.runtimeType &&
      busy == other.busy;
  }

  @override
  int get hashCode => busy.hashCode;
}
