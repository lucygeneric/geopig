

class InterfaceState {

  bool busy;
  int pageIndex;

  InterfaceState({
    busy,
    pageIndex
  }) {
    this.busy = busy;
    this.pageIndex = pageIndex;
  }

  InterfaceState copy({ bool busy, int pageIndex }) {
    return InterfaceState(
      busy: busy ?? this.busy,
      pageIndex: pageIndex ?? this.pageIndex
    );
  }

  static InterfaceState initialState() => InterfaceState(busy: false, pageIndex: 0);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is InterfaceState &&
      runtimeType == other.runtimeType &&
      busy == other.busy &&
      pageIndex == other.pageIndex;
  }

  @override
  int get hashCode => busy.hashCode ^ pageIndex.hashCode;
}
