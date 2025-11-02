class Usermodel {
  final String uuid;
  final String name;
  final String email;
  final String? isLinkedDevice;

  Usermodel({required this.uuid, required this.name, required this.email,this.isLinkedDevice});

  factory Usermodel.fromJson(Map<String, dynamic> json) {
    return Usermodel(
      uuid: json['uuid'],
      name: json['name'],
      email: json['email'],
      isLinkedDevice: json['isLinkedDevice']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'email': email,
      'isLinkedDevice': isLinkedDevice,
    };
  }
}