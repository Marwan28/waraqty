import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'document_builder_state.dart';

class DocumentBuilderCubit extends Cubit<DocumentBuilderState> {
  DocumentBuilderCubit() : super(DocumentBuilderInitial());
}
