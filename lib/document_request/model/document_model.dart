class DocumentModel {
  final String rfdoc_code;
  final String rfdoc_adddate;
  final String rfdoc_note;
  final String rfdoc_doc_type;
  final String rfdoc_status;

  DocumentModel(
      {required this.rfdoc_code,
      required this.rfdoc_adddate,
      required this.rfdoc_note,
      required this.rfdoc_doc_type,
      required this.rfdoc_status});
}
