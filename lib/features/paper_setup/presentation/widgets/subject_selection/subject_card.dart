import 'package:flutter/material.dart';
import 'package:waraqty/features/paper_setup/domain/entities/subject_entity.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/subject_selection/available_subject_card.dart';
import 'package:waraqty/features/paper_setup/presentation/widgets/subject_selection/unavailable_subject_card.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    required this.isSelected,
    required this.onTap,
  });

  final SubjectEntity subject;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!subject.isAvailable) {
      return UnavailableSubjectCard(subject: subject);
    }

    return AvailableSubjectCard(
      subject: subject,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
