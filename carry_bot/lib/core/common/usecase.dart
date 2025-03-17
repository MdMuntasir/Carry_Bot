import '../connection state/data_state.dart';

abstract class UseCase<Type, Params> {
  Future<DataState<Type>> call({Params para});
}