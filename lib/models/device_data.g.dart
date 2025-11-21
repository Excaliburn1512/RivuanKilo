
part of 'device_data.dart';
DeviceData _$DeviceDataFromJson(Map json) => DeviceData(
      aktuatorStatus: AktuatorStatus.fromJson(
          Map<String, dynamic>.from(json['aktuator_status'] as Map)),
      controlCommand: ControlCommand.fromJson(
          Map<String, dynamic>.from(json['control_command'] as Map)),
      controlValue: ControlValue.fromJson(
          Map<String, dynamic>.from(json['control_value'] as Map)),
      picture:
          Picture.fromJson(Map<String, dynamic>.from(json['picture'] as Map)),
      sensorValue: SensorValue.fromJson(
          Map<String, dynamic>.from(json['sensor_value'] as Map)),
    );
Map<String, dynamic> _$DeviceDataToJson(DeviceData instance) =>
    <String, dynamic>{
      'aktuator_status': instance.aktuatorStatus.toJson(),
      'control_command': instance.controlCommand.toJson(),
      'control_value': instance.controlValue.toJson(),
      'picture': instance.picture.toJson(),
      'sensor_value': instance.sensorValue.toJson(),
    };
AktuatorStatus _$AktuatorStatusFromJson(Map json) => AktuatorStatus(
      keranKolam: json['keran_kolam'] as String?,
      keranNutrisi: json['keran_nutrisi'] as String?,
      kipas: json['kipas'] as String?,
      pompaFilterKolam: json['pompa_filter_kolam'] as String?,
      pompaKolam: json['pompa_kolam'] as String?,
      pompaNutrisi: json['pompa_nutrisi'] as String?,
    );
Map<String, dynamic> _$AktuatorStatusToJson(AktuatorStatus instance) =>
    <String, dynamic>{
      'keran_kolam': instance.keranKolam,
      'keran_nutrisi': instance.keranNutrisi,
      'kipas': instance.kipas,
      'pompa_filter_kolam': instance.pompaFilterKolam,
      'pompa_kolam': instance.pompaKolam,
      'pompa_nutrisi': instance.pompaNutrisi,
    };
ControlCommand _$ControlCommandFromJson(Map json) => ControlCommand(
      liveKolam: json['live_kolam'] as bool?,
      scanTanaman: json['scan_tanaman'] as bool?,
    );
Map<String, dynamic> _$ControlCommandToJson(ControlCommand instance) =>
    <String, dynamic>{
      'live_kolam': instance.liveKolam,
      'scan_tanaman': instance.scanTanaman,
    };
ControlValue _$ControlValueFromJson(Map json) => ControlValue(
      kipasManual: json['kipas_manual'] as String?,
      timerJedaPompa: json['timer_jeda_pompa'] as String?,
      timerPompaFilterOff: json['timer_pompa_filter_off'] as String?,
      timerPompaFilterOn: json['timer_pompa_filter_on'] as String?,
      timerPompaKolam: json['timer_pompa_kolam'] as String?,
      timerPompaNutrisi: json['timer_pompa_nutrisi'] as String?,
    );
Map<String, dynamic> _$ControlValueToJson(ControlValue instance) =>
    <String, dynamic>{
      'kipas_manual': instance.kipasManual,
      'timer_jeda_pompa': instance.timerJedaPompa,
      'timer_pompa_filter_off': instance.timerPompaFilterOff,
      'timer_pompa_filter_on': instance.timerPompaFilterOn,
      'timer_pompa_kolam': instance.timerPompaKolam,
      'timer_pompa_nutrisi': instance.timerPompaNutrisi,
    };
Picture _$PictureFromJson(Map json) => Picture(
      plant1: json['plant1'] as String?,
      plant2: json['plant2'] as String?,
      plant3: json['plant3'] as String?,
      plant4: json['plant4'] as String?,
    );
Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'plant1': instance.plant1,
      'plant2': instance.plant2,
      'plant3': instance.plant3,
      'plant4': instance.plant4,
    };
SensorValue _$SensorValueFromJson(Map json) => SensorValue(
      intensitasCahaya: json['intensitas_cahaya'] as String?,
      kelembapanUdara: json['kelembapan_udara'] as String?,
      permukaanNutrisi: json['permukaan_nutrisi'] as String?,
      phKolam: json['ph_kolam'] as String?,
      suhuAir: json['suhu_air'] as String?,
      suhuUdara: json['suhu_udara'] as String?,
      permukaanKolam: json['permukaan_kolam'] as String?,
      tdsKolam: json['tds_kolam'] as String?,
      tdsNutrisi: json['tds_nutrisi'] as String?,
    );
Map<String, dynamic> _$SensorValueToJson(SensorValue instance) =>
    <String, dynamic>{
      'intensitas_cahaya': instance.intensitasCahaya,
      'kelembapan_udara': instance.kelembapanUdara,
      'permukaan_kolam': instance.permukaanKolam,
      'permukaan_nutrisi': instance.permukaanNutrisi,
      'ph_kolam': instance.phKolam,
      'suhu_air': instance.suhuAir,
      'suhu_udara': instance.suhuUdara,
      'tds_kolam': instance.tdsKolam,
      'tds_nutrisi': instance.tdsNutrisi,
    };
