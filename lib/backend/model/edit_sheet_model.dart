class EditSheetResult {
  final String title;
  final String? description;
  final String? player;
  final String? visibility;

  EditSheetResult({
    required this.title,
    this.description,
    this.player,
    this.visibility,
  });
}