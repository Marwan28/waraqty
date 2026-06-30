import 'package:equatable/equatable.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';

class DocumentSectionEntity extends Equatable {
  final QuestionCategoryType category;
  final List<QuestionEntity> questions;

  const DocumentSectionEntity({
    required this.category,
    required this.questions,
  });

  String get title => category.title;

  @override
  List<Object?> get props => [category, questions];
}
