// ignore_for_file: constant_identifier_names, file_names

enum TeamConnectionProvider {
  DISCORD,
  PHONE,
  EMAIL,
  WHATSAPP,
}

class TeamConnection {
  TeamConnectionProvider provider;
  String username;

  TeamConnection(this.provider, this.username);
}
