class CompatibilityCheckFunctions {
  bool handlePcieCompatibility(String pcieInput, String pcieTarget) {
    String pcieInputPin =
        pcieInput.substring(pcieInput.indexOf('x'), pcieInput.length);
    String pcieTargetPin =
        pcieInput.substring(pcieTarget.indexOf('x'), pcieInput.length);

    //Any PCIE version works
    if (pcieInputPin == pcieTargetPin) {
      return true;
    }
    return false;
  }

  bool handlePcieCompatibilityWithJson(
      String pcieInput, Map<String, dynamic> serializedPcieJson) {
    bool _isCompatible = false;
    serializedPcieJson.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        if (handlePcieCompatibility(pcieInput, value[i])) {
          _isCompatible = true;
          break;
        }
      }
    });

    return _isCompatible;
  }
}
