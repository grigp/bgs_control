class CommunicationLogger{
  final List<String> _log = [];

  void log(String message){
    _log.add(message);
  }

  List<String> get() =>_log;

  void clear(){
    _log.clear();
  }

}