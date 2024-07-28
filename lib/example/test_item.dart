class TestItem {
  TestItem({required this.label, required this.index, this.description = ""});

  final String label;
  final int index;

  final String description;

  @override
  String toString() {
    return label;
  }

  @override
  int get hashCode => label.hashCode;
  @override
  bool operator ==(Object other) {
    if (other is TestItem) {
      return label == other.label;
    }
    return false;
  }
}
