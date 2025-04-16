import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leafmusic_2/core/auth_manager.dart';
import 'package:leafmusic_2/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      try {
        final data = await authRepository.login(event.email, event.password);

        await AuthManager.saveUserInfo(
          token: (data['token'] ?? '').toString(),
          userId: (data['userId'] ?? '').toString(),
          username: (data['username'] ?? '').toString(),
          email: (data['email'] ?? '').toString(),
        );

        ///IN LOG ĐỂ CHECK DỮ LIỆU :))
        print("Token: ${data['token']}");
        print("UserId: ${data['userId']}");
        print("Username: ${data['username']}");
        print("Email: ${data['email']}");


        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
