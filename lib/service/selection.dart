class GlobalSelectionManager {
  Set<int> selectedIndexes = {};

  int getTotalSelectionCount() {
    return selectedIndexes.length;
  }
}

final GlobalSelectionManager globalSelectionManager = GlobalSelectionManager();
