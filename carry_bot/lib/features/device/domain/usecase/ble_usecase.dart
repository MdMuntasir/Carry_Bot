import 'package:carry_bot/core/common/usecase.dart';
import 'package:carry_bot/features/device/domain/repository/device_repository.dart';

import '../../../../core/connection state/data_state.dart';

class SendBleMessageUseCase implements UseCase<dynamic,String>{
  final DeviceRepository deviceRepository;
  const SendBleMessageUseCase(this.deviceRepository);

  @override
  Future<DataState> call({String? para}) async{
    return await deviceRepository.sendMessageBle(para!);
  }
}

