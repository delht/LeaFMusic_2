
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_event.dart';
import 'package:leafmusic_2/bloc/customlist/customlist_state.dart';
import 'package:leafmusic_2/repositories/customlist_repository.dart';

class CustomlistBloc extends Bloc<CustomlistEvent, CustomlistState> {

  final CustomListRepository customListRepository;

  CustomlistBloc({required this.customListRepository}) : super(CustomListInitial()) {
    on<LoadCustomlists>(_onLoadCustomList);
    on<AddCustomList>(_onAddCustomList);
    on<UpdateCustomList>(_onUpdateCustomList);
    on<DeleteCustomList>(_onDeleteCustomList);

  }


  // =================================================================

  void _onLoadCustomList(LoadCustomlists event, Emitter<CustomlistState> emit) async {
    emit(CustomListLoading());
    try {
      final customlists = await customListRepository.fetchCustomList(event.id_user);
      emit(CustomListLoaded(customlists));
    } catch (e) {
      emit(CustomListError("Lấy dữ liệu danh sách thất bại")); ///Lỗi
    }
  }

  void _onAddCustomList(AddCustomList event, Emitter<CustomlistState> emit) async {
    try {
      await customListRepository.addCustomList(event.name, event.idUser);
      add(LoadCustomlists(event.idUser));
    } catch (e) {
      emit(CustomListError("Tạo danh sách mới thất bại"));
    }
  }

  void _onUpdateCustomList(UpdateCustomList event, Emitter<CustomlistState> emit) async {
    try {
      await customListRepository.updateCustomList(event.idList, event.newName);
      add(LoadCustomlists(event.idUser));
    } catch (_) {
      emit(CustomListError("Sửa danh sách thất bại"));
    }
  }

  void _onDeleteCustomList(DeleteCustomList event, Emitter<CustomlistState> emit) async {
    try {
      await customListRepository.deleteCustomList(event.idList);
      add(LoadCustomlists(event.idUser));
    } catch (_) {
      emit(CustomListError("Xóa danh sách thất bại"));
    }
  }


}