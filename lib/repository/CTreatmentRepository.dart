import 'package:control_medico3/dao/CConfigDosisDao.dart';
import 'package:control_medico3/dao/CTreatmentDao.dart';
import 'package:control_medico3/model/CConfigDosis.dart';
import 'package:control_medico3/model/CTreatment.dart';

class CTreatmentRepository{
  final CTreatmentDao treatmentDao=CTreatmentDao();
  final CConfigDosisDao configDosisDao=CConfigDosisDao();

  Future<int> createCTreatment(CTreatment cTreatment) async{
    int cTreatmentResult=await treatmentDao.createCTreatment(cTreatment);
    cTreatment.configDosis.setIdTreatment=cTreatmentResult;
    var cConfigResult=await configDosisDao.createCConfigDosis(cTreatment.configDosis);
    return cTreatmentResult;
  }

  Future<List<CTreatment>> getCTreatments({List<String> columns,Map<String,dynamic> query}) async{
    List<CTreatment> cTreatments=await treatmentDao.getCTreatments(columns:columns,query:query);
    for(CTreatment treatment in cTreatments){
      CConfigDosis configDosis= await configDosisDao.getCConfigDosis(treatment.id);
      treatment.configDosis=configDosis;
    }
    return cTreatments;
  }

  Future<CTreatment> getCTreatment(int id) async{
    CTreatment cTreatment = await treatmentDao.getCTreatment(id);
    CConfigDosis cConfigDosis=await configDosisDao.getCConfigDosis(id);
    cTreatment.setConfigDosis=cConfigDosis;
    return cTreatment;
  }

  Future<int> updateCTreatment(CTreatment treatment) async{
    int resultCTreatmentUpdate=await treatmentDao.updateCTreatment(treatment);
    int resultCConfigDosisUpdate=await configDosisDao.updateCConfigDosis(treatment.configDosis);
    return resultCConfigDosisUpdate;
  }

  Future<int> deleteCTreatment(int id) async{
    int resultCTreatmentDelete=await treatmentDao.deleteCTreatment(id);
    int resultCConfigDosisDelete=await configDosisDao.deleteCConfigDosis(id);
    return resultCConfigDosisDelete;
  }

  Future<int> deleteAllCTreatments() async{
    int resultCTreatmentsDelete=await treatmentDao.deleteAllCTreatment();
    int resultCConfigDosisDelete=await configDosisDao.deleteAllCConfigDosis();
    return resultCConfigDosisDelete;
  }
  
}