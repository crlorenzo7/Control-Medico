enum MedicationType{
  inyeccion_subcutanea,
  pastillas,
  capsulas,
  sobres,
  jarabe,
  efervescente

  
}

String medicationTypetoString(MedicationType mt){
  switch(mt){
    case MedicationType.inyeccion_subcutanea:return "Inyeccion Subcutanea";break;
    case MedicationType.pastillas: return "Pastillas";break;
    case MedicationType.capsulas: return "Capsulas" ;break;
    case MedicationType.sobres: return "Sobres" ;break;
    case MedicationType.jarabe: return "Jarabe" ;break;
    default: return "Efervescente" ;break;
  }
}