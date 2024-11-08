class M2PSettings {
  String m2pTitle;
  String m2pSubTitle;
  String m2pCancelCTA;

  M2PSettings({
    required this.m2pTitle,
    required this.m2pSubTitle,
    required this.m2pCancelCTA,
  });

  // Convert the object to a map for encoding as JSON
  Map<String, String> toMap() {
    return {
      'm2pTitle': m2pTitle,
      'm2pSubTitle': m2pSubTitle,
      'm2pCancelCTA': m2pCancelCTA,
    };
  }

  // Create an object from a map (decoding JSON)
  factory M2PSettings.fromMap(Map<String, String> map) {
    return M2PSettings(
      m2pTitle: map['m2pTitle'] ?? '',
      m2pSubTitle: map['m2pSubTitle'] ?? '',
      m2pCancelCTA: map['m2pCancelCTA'] ?? '',
    );
  }
}