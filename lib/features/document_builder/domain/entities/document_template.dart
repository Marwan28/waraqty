enum BookletTemplate {
  classic(id: 'classic', title: 'كلاسيكي'),
  organized(id: 'organized', title: 'منظم'),
  revision(id: 'revision', title: 'مراجعة');

  const BookletTemplate({required this.id, required this.title});

  final String id;
  final String title;
}

enum ExamTemplate {
  official(id: 'official', title: 'رسمي'),
  framed(id: 'framed', title: 'بإطار'),
  compact(id: 'compact', title: 'مضغوط');

  const ExamTemplate({required this.id, required this.title});

  final String id;
  final String title;
}
