enum PaperType { booklet, exam }

class PaperTypeEntity {
  final String id;
  final PaperType type;
  final String title;
  final String subtitle;

  const PaperTypeEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
  });
}
