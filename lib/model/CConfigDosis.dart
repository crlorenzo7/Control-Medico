class CConfigDosis{
  int idTreatment;
  int frequencyDays;
  int diaryTimes;
  List<int> dosisTime=[];

  CConfigDosis({this.idTreatment,this.frequencyDays=1,this.diaryTimes=1,this.dosisTime});

  factory CConfigDosis.fromMap(Map<String, dynamic> json) => new CConfigDosis(
        idTreatment: json["idTreatment"],
        frequencyDays: json["frequencyDays"],
        diaryTimes: json["diaryTimes"],
        dosisTime: (json.containsKey("dosisTime") && json["dosisTime"]!=null) ? json["dosisTime"].split(",").where((i)=>i!="").map((i)=>int.parse(i)).toList().cast<int>():[],
      );

  Map<String, dynamic> toMap() => {
        "idTreatment":idTreatment,
        "frequencyDays": frequencyDays,
        "diaryTimes": diaryTimes,
        "dosisTime": dosisTime!=null ? dosisTime.join(","):null,
      };

    int get getIdTreatment => idTreatment;
    int get getFrequencyDays => frequencyDays;
    int get getDiaryTimes => diaryTimes;
    List<int> get getDosisTime => dosisTime;

    set setIdTreatment(int idTreatment){this.idTreatment=idTreatment;}
    set setFrequencyDaty(int frequencyDays){this.frequencyDays=frequencyDays;}
    set setDiaryTimes(int diaryTimes){this.diaryTimes=diaryTimes;}
    set setDosisTime(List<int> dosisTime){this.dosisTime=dosisTime;}

    void addDosisTime(int dt){dosisTime.add(dt);}
    void removeDosisTime(int position){dosisTime.removeAt(position);}
}