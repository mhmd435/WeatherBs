
import 'package:bloc/bloc.dart';

class BottomIconCubit extends Cubit<int> {
  BottomIconCubit() : super(0);

  void gotoHome() => emit(0);

  void gotoBookMark() => emit(1);
}
