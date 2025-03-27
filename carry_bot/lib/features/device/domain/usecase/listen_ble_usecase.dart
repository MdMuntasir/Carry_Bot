import 'package:carry_bot/core/common/usecase.dart';
import 'package:carry_bot/core/connection%20state/data_state.dart';
import 'package:flutter/cupertino.dart';

import '../repository/device_repository.dart';

class ListenBleUseCase implements UseCase<dynamic, BuildContext>{
  final DeviceRepository deviceRepository;
  const ListenBleUseCase(this.deviceRepository);

  @override
  Future<DataState> call({BuildContext? para}) async{
    return await deviceRepository.listenBle(para!);
  }
}