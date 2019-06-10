class User {
  String referenceID;
  String mctsNumber;
  String respondentName;
  String telephoneNumber;
  int noOfFamilyMembersDeceased;
  int noOfChildren;
  String caste;
  String religion;
  int isBelowPovertyLine = -1;
  int careOutsideHome = -1;
  bool illnessWasSerious = false;
  bool moneyAvailable = false;
  bool familyAbleToAccompany = false;
  bool badWeather = false;
  bool whereToTakeInfant = false;
  bool noHopesOfSurvival = false;
  bool transportAvailability = false;
  String othersNo ='';
  bool quack = false;
  bool traditionalHealer = false;
  bool subCentre = false;
  bool phc = false;
  bool chc = false;
  bool subDistrictHospital = false;
  bool districtGovtHospital = false;
  bool privateAllopathic = false;
  bool doctorAlternateSystem = false;
  String reasonForSeekingCare = '' ;
  int adviceOnHospitalTreatment = -1;
  int conditionOfInfantAtConsultation = -1;
  String dischargedAgainstMedicalAdvice;
  String diedBeforeDischarge;
  String dissatisfactionTreatment;
  String dangerSigns;

}
