
import 'package:json_annotation/json_annotation.dart';
part 'device_data.g.dart';
@JsonSerializable(explicitToJson: true, anyMap: true)
class DeviceData {
  @JsonKey(name: 'aktuator_status')
  final AktuatorStatus aktuatorStatus;
  @JsonKey(name: 'control_command')
  final ControlCommand controlCommand;
  @JsonKey(name: 'control_value')
  final ControlValue controlValue;
  @JsonKey(name: 'picture')
  final Picture picture;
  @JsonKey(name: 'sensor_value')
  final SensorValue sensorValue;
  DeviceData({
    required this.aktuatorStatus,
    required this.controlCommand,
    required this.controlValue,
    required this.picture,
    required this.sensorValue,
  });
  factory DeviceData.fromJson(Map<String, dynamic> json) =>
      _$DeviceDataFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceDataToJson(this);
  factory DeviceData.empty() => DeviceData(
    aktuatorStatus: AktuatorStatus.empty(),
    controlCommand: ControlCommand.empty(),
    controlValue: ControlValue.empty(),
    picture: Picture.empty(),
    sensorValue: SensorValue.empty(),
  );
}
@JsonSerializable(anyMap: true)
class AktuatorStatus {
  @JsonKey(name: 'keran_kolam')
  final String? keranKolam;
  @JsonKey(name: 'keran_nutrisi')
  final String? keranNutrisi;
  final String? kipas;
  @JsonKey(name: 'pompa_filter_kolam')
  final String? pompaFilterKolam;
  @JsonKey(name: 'pompa_kolam')
  final String? pompaKolam;
  @JsonKey(name: 'pompa_nutrisi')
  final String? pompaNutrisi;
  AktuatorStatus({
    this.keranKolam,
    this.keranNutrisi,
    this.kipas,
    this.pompaFilterKolam,
    this.pompaKolam,
    this.pompaNutrisi,
  });
  factory AktuatorStatus.fromJson(Map<String, dynamic> json) =>
      _$AktuatorStatusFromJson(json);
  Map<String, dynamic> toJson() => _$AktuatorStatusToJson(this);
  factory AktuatorStatus.empty() => AktuatorStatus(
    keranKolam: "",
    keranNutrisi: "",
    kipas: "",
    pompaFilterKolam: "",
    pompaKolam: "",
    pompaNutrisi: "",
  );
}
@JsonSerializable(anyMap: true)
class ControlCommand {
  @JsonKey(name: 'live_kolam')
  final bool? liveKolam;
  @JsonKey(name: 'scan_tanaman')
  final bool? scanTanaman;
  ControlCommand({this.liveKolam, this.scanTanaman});
  factory ControlCommand.fromJson(Map<String, dynamic> json) =>
      _$ControlCommandFromJson(json);
  Map<String, dynamic> toJson() => _$ControlCommandToJson(this);
  factory ControlCommand.empty() =>
      ControlCommand(liveKolam: false, scanTanaman: false);
}
@JsonSerializable(anyMap: true)
class ControlValue {
  @JsonKey(name: 'kipas_manual')
  final String? kipasManual;
  @JsonKey(name: 'timer_jeda_pompa')
  final String? timerJedaPompa;
  @JsonKey(name: 'timer_pompa_filter_off')
  final String? timerPompaFilterOff;
  @JsonKey(name: 'timer_pompa_filter_on')
  final String? timerPompaFilterOn;
  @JsonKey(name: 'timer_pompa_kolam')
  final String? timerPompaKolam;
  @JsonKey(name: 'timer_pompa_nutrisi')
  final String? timerPompaNutrisi;
  ControlValue({
    this.kipasManual,
    this.timerJedaPompa,
    this.timerPompaFilterOff,
    this.timerPompaFilterOn,
    this.timerPompaKolam,
    this.timerPompaNutrisi,
  });
  factory ControlValue.fromJson(Map<String, dynamic> json) =>
      _$ControlValueFromJson(json);
  Map<String, dynamic> toJson() => _$ControlValueToJson(this);
  factory ControlValue.empty() => ControlValue(
    kipasManual: "",
    timerJedaPompa: "",
    timerPompaFilterOff: "",
    timerPompaFilterOn: "",
    timerPompaKolam: "",
    timerPompaNutrisi: "",
  );
}
@JsonSerializable(anyMap: true)
class Picture {
  final String? plant1;
  final String? plant2;
  final String? plant3;
  final String? plant4;
  Picture({this.plant1, this.plant2, this.plant3, this.plant4});
  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);
  Map<String, dynamic> toJson() => _$PictureToJson(this);
  factory Picture.empty() =>
      Picture(plant1: "", plant2: "", plant3: "", plant4: "");
}
@JsonSerializable(anyMap: true)
class SensorValue {
  @JsonKey(name: 'intensitas_cahaya')
  final String? intensitasCahaya;
  @JsonKey(name: 'kelembapan_udara')
  final String? kelembapanUdara;
  @JsonKey(name: 'permukaan_kolam')
  final String? permukaanKolam;
  @JsonKey(name: 'permukaan_nutrisi')
  final String? permukaanNutrisi;
  @JsonKey(name: 'ph_kolam')
  final String? phKolam;
  @JsonKey(name: 'suhu_air')
  final String? suhuAir;
  @JsonKey(name: 'suhu_udara')
  final String? suhuUdara;
  @JsonKey(name: 'tds_kolam')
  final String? tdsKolam;
  @JsonKey(name: 'tds_nutrisi')
  final String? tdsNutrisi;
  SensorValue({
    this.intensitasCahaya,
    this.kelembapanUdara,
    this.permukaanNutrisi,
    this.phKolam,
    this.suhuAir,
    this.suhuUdara,
    this.permukaanKolam,
    this.tdsKolam,
    this.tdsNutrisi,
  });
  factory SensorValue.fromJson(Map<String, dynamic> json) =>
      _$SensorValueFromJson(json);
  Map<String, dynamic> toJson() => _$SensorValueToJson(this);
  factory SensorValue.empty() => SensorValue(
    kelembapanUdara: "",
    phKolam: "",
    suhuUdara: "",
    tdsKolam: "",
    tdsNutrisi: "",
    permukaanKolam: "",
    permukaanNutrisi: "",
    suhuAir: "",
    intensitasCahaya: "",
  );
}
