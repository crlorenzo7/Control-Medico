

import 'package:control_medico3/dao/CEventDao.dart';
import 'package:control_medico3/model/CEvent.dart';

class CEventRepository{
  final CEventDao eventDao=CEventDao();

  CEventRepository();

  Future createCEvent(CEvent cEvent) => eventDao.createCEvent(cEvent);
  Future getCEvents({List<String> columns,Map<String,dynamic> query}) => eventDao.getCEvents(columns,query);
  Future getCEvent(int id)=>eventDao.getCEvent(id);
  Future updateCEvent(CEvent cEvent)=>eventDao.updateCEvent(cEvent);
  Future deleteCEvent(int id)=>eventDao.deleteCEvent(id);
  Future deleteAllCEvents()=>eventDao.deleteAllCEvents();
  Future initHistory()=>eventDao.getSettings();
  
}