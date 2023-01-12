import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  SurveyCubit() : super(SurveyInitial('', []));
}
