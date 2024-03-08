// ignore_for_file: public_member_api_docs, sort_constructors_first
class Drug {
  int? id;
  String name;
  String dosage;
  String consumCases;
  String prohibitCases;
  String drugDisorders;
  String foodDisorders;
  String consumRoles;
  String descriptions;

  Drug({
    this.id,
    required this.name,
    required this.dosage,
    required this.consumCases,
    required this.prohibitCases,
    required this.drugDisorders,
    required this.foodDisorders,
    required this.consumRoles,
    required this.descriptions,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      "dosage": dosage,
      "consum_cases": consumCases,
      "prohibit_cases": prohibitCases,
      "drug_disorders": drugDisorders,
      "food_disorders": foodDisorders,
      "consum_roles": consumRoles,
      "descriptions": descriptions,
    };
  }

  @override
  toString(){
    return "$name -> $id";
  }
}

class Category {
  int? id;
  String name;

  Category({
    required this.name,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {"name": name};
  }
}

class Shape {
  int? id;
  String name;

  Shape({
    required this.name,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {"name": name};
  }
}

class DrugToShape {
  int? id;
  int drug;
  int shape;

  DrugToShape({
    this.id,
    required this.drug,
    required this.shape,
  });

  Map<String, dynamic> toMap() {
    return {"drug": drug, "shape": shape};
  }
}

class DrugToCategory {
  int? id;
  int drug;
  int category;

  DrugToCategory({
    this.id,
    required this.drug,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {"drug": drug, "category": category};
  }
}
