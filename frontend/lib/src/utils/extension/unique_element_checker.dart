extension UniqueElementsExtension<T> on List<T> {
  bool hasUniqueElements() {
    // Convert the list to a Set to remove duplicate elements
    Set<T> set = Set.from(this);

    // Compare the lengths of the original list and the Set
    return (length == set.length);
  }

  bool containsMoreThanOneOne() {
    // Count the occurrences of "1" in the list
    int count = where((element) => element == 1).length;

    // Check if the count is greater than 1
    return count > 1;
  }
}
