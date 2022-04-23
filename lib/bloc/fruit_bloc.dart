import 'package:bloc/bloc.dart';
import 'package:fruit/model/fruit.dart';
import 'package:fruit/repository/FruitRepository.dart';
import 'package:meta/meta.dart';

part 'fruit_event.dart';
part 'fruit_state.dart';

class FruitBloc extends Bloc<FruitEvent, FruitState> {

  final FruitRepository _fruitRepository;

  FruitBloc(this._fruitRepository,) : super(FruitInitial()) {
    on<FetchItems>(_fetchItems);
  }

  _fetchItems(FetchItems event, Emitter emit) async {
    emit(Loading());
    final result = await _fruitRepository.fetchItems(
        imageReference: true,
        referenceId: '1650165235',
    );
    if (result.isError) {
      emit(FetchFailed(error: result.asError?.error));
    }
    else {
      emit(FetchSuccess(items: result.asValue?.value ?? []));
    }
  }
}
