import 'dart:convert';

SearchSuggestionModel searchSuggestionModelFromJson(String str) => SearchSuggestionModel.fromJson(json.decode(str));

String searchSuggestionModelToJson(SearchSuggestionModel data) => json.encode(data.toJson());

class SearchSuggestionModel {
  bool success;
  String message;
  Data data;
  int status;
  dynamic error;

  SearchSuggestionModel({
    required this.success,
    required this.message,
    required this.data,
    required this.status,
    this.error,
  });

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) => SearchSuggestionModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
        status: json["status"] ?? 0,
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "status": status,
        "error": error,
      };
}

class Data {
  String searchTerm;
  List<SuggestionCategory> suggestions;

  Data({
    required this.searchTerm,
    required this.suggestions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        searchTerm: json["searchTerm"] ?? "",
        suggestions: json["suggestions"] == null
            ? []
            : List<SuggestionCategory>.from(json["suggestions"].map((x) => SuggestionCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "searchTerm": searchTerm,
        "suggestions": List<dynamic>.from(suggestions.map((x) => x.toJson())),
      };
}

class SuggestionCategory {
  String category;
  String label;
  List<SuggestionItem> items;

  SuggestionCategory({
    required this.category,
    required this.label,
    required this.items,
  });

  factory SuggestionCategory.fromJson(Map<String, dynamic> json) => SuggestionCategory(
        category: json["category"] ?? "",
        label: json["label"] ?? "",
        items: json["items"] == null ? [] : List<SuggestionItem>.from(json["items"].map((x) => SuggestionItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "label": label,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class SuggestionItem {
  String id;
  String value;
  String? displayValue;
  String filterField;
  String filterOperator;

  SuggestionItem({
    required this.id,
    required this.value,
    this.displayValue,
    required this.filterField,
    required this.filterOperator,
  });

  factory SuggestionItem.fromJson(Map<String, dynamic> json) => SuggestionItem(
        id: json["id"] ?? "",
        value: json["value"] ?? "",
        displayValue: json["displayValue"],
        filterField: json["filterField"] ?? "",
        filterOperator: json["filterOperator"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "displayValue": displayValue,
        "filterField": filterField,
        "filterOperator": filterOperator,
      };
}
