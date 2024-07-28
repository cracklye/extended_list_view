class TestItem {
  TestItem({required this.label, this.description = ""});

  final String label;

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
