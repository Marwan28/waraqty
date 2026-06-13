import 'package:bloc/bloc.dart';

part 'document_builder_state.dart';

class DocumentBuilderCubit extends Cubit<DocumentBuilderState> {
  DocumentBuilderCubit() : super(DocumentBuilderInitial());
}
