import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final LogInData logInData;
  final String accessToken;
  final String refreshToken;
  final int status;
  final String message;

  LoginModel({required this.logInData, required this.accessToken, required this.refreshToken, required this.status, required this.message});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    logInData: LogInData.fromJson(json["data"] ?? {}),
    accessToken: json["accessToken"] ?? "",
    refreshToken: json["refreshToken"] ?? "",
    status: json["status"] ?? 0,
    message: json["message"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "logInData": logInData.toJson(),
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "status": status,
    "message": message,
  };
}

class LogInData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isVerified;
  final bool isBlocked;
  final String dbName;
  final String orgId;
  final String subDomain;
  final int maxQuotationDiscount;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final dynamic deletedAt;
  final RoleId roleId;
  final TenantId tenantId;
  final RolePermission rolePermission;

  LogInData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
    required this.isBlocked,
    required this.dbName,
    required this.orgId,
    required this.subDomain,
    required this.maxQuotationDiscount,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.deletedAt,
    required this.roleId,
    required this.tenantId,
    required this.rolePermission,
  });

  factory LogInData.fromJson(Map<String, dynamic> json) => LogInData(
    id: json["id"] ?? "",
    email: json["email"] ?? "",
    firstName: json["first_name"] ?? "",
    lastName: json["last_name"] ?? "",
    isVerified: json["is_verified"] ?? false,
    isBlocked: json["is_blocked"] ?? false,
    dbName: json["db_name"] ?? "",
    orgId: json["org_id"] ?? "",
    subDomain: json["sub_domain"] ?? "",
    maxQuotationDiscount: json["max_quotation_discount"] ?? 0,
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"] ?? "",
    roleId: RoleId.fromJson(json["role_id"] ?? {}),
    tenantId: TenantId.fromJson(json["tenant_id"] ?? {}),
    rolePermission: RolePermission.fromJson(json["rolePermission"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "is_verified": isVerified,
    "is_blocked": isBlocked,
    "db_name": dbName,
    "org_id": orgId,
    "sub_domain": subDomain,
    "max_quotation_discount": maxQuotationDiscount,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "role_id": roleId.toJson(),
    "tenant_id": tenantId.toJson(),
    "rolePermission": rolePermission.toJson(),
  };
}

class RoleId {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final dynamic deletedAt;

  RoleId({required this.id, required this.name, required this.createdAt, required this.updatedAt, required this.isDeleted, required this.deletedAt});

  factory RoleId.fromJson(Map<String, dynamic> json) => RoleId(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
  };
}

class RolePermission {
  final RolePermissionOperations operations;
  final Admin admin;
  final Purchase purchase;

  RolePermission({required this.operations, required this.admin, required this.purchase});

  factory RolePermission.fromJson(Map<String, dynamic> json) => RolePermission(
    operations: RolePermissionOperations.fromJson(json["operations"] ?? {}),
    admin: Admin.fromJson(json["admin"] ?? {}),
    purchase: Purchase.fromJson(json["purchase"] ?? {}),
  );

  Map<String, dynamic> toJson() => {"operations": operations.toJson(), "admin": admin.toJson(), "purchase": purchase.toJson()};
}

class Admin {
  final String id;
  final int rowLevel;
  final String name;
  final PermissionClass operations;
  final String identifier;
  final PermissionClass permission;
  final AdminChildData childData;

  Admin({
    required this.id,
    required this.rowLevel,
    required this.name,
    required this.operations,
    required this.identifier,
    required this.permission,
    required this.childData,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json["id"] ?? "",
    rowLevel: json["row_level"] ?? 0,
    name: json["name"] ?? "",
    operations: PermissionClass.fromJson(json["operations"] ?? {}),
    identifier: json["identifier"] ?? "",
    permission: PermissionClass.fromJson(json["permission"] ?? {}),
    childData: AdminChildData.fromJson(json["childData"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "row_level": rowLevel,
    "name": name,
    "operations": operations.toJson(),
    "identifier": identifier,
    "permission": permission.toJson(),
    "childData": childData.toJson(),
  };
}

class AdminChildData {
  final Address commonoperations;
  final Address cities;
  final Address pin;
  final Address users;
  final Address gpsMaster;
  final Address tripsheetview;
  final Address commonapiconfiguration;
  final Address mapMaster;
  final Address fastagMaster;
  final Address dieselMaster;
  final Address zone;
  final Address customerGroup;
  final Address customerGroupCreate;
  final Address customerGroupUpdate;
  final Address location;
  final Address branch;
  final Address product;
  final Address combomaster;
  final Address ledgers;
  final Address invoicemaster;
  final Address taxMaster;
  final Address hsnMaster;
  final Address customersWalkIn;
  final Address agent;
  final Address updateAgent;
  final Address locationHierarchyUpdate;
  final Address locationHierarchyCreate;
  final Address vendor;
  final Address vendorCreate;
  final Address locationHierarchy;
  final Address vendorUpdate;
  final Address stock;
  final Address address;

  AdminChildData({
    required this.commonoperations,
    required this.cities,
    required this.pin,
    required this.users,
    required this.gpsMaster,
    required this.tripsheetview,
    required this.commonapiconfiguration,
    required this.mapMaster,
    required this.fastagMaster,
    required this.dieselMaster,
    required this.zone,
    required this.customerGroup,
    required this.customerGroupCreate,
    required this.customerGroupUpdate,
    required this.location,
    required this.branch,
    required this.product,
    required this.combomaster,
    required this.ledgers,
    required this.invoicemaster,
    required this.taxMaster,
    required this.hsnMaster,
    required this.customersWalkIn,
    required this.agent,
    required this.updateAgent,
    required this.locationHierarchyUpdate,
    required this.locationHierarchyCreate,
    required this.vendor,
    required this.vendorCreate,
    required this.locationHierarchy,
    required this.vendorUpdate,
    required this.stock,
    required this.address,
  });

  factory AdminChildData.fromJson(Map<String, dynamic> json) => AdminChildData(
    commonoperations: Address.fromJson(json["commonoperations"] ?? {}),
    cities: Address.fromJson(json["cities"] ?? {}),
    pin: Address.fromJson(json["pin"] ?? {}),
    users: Address.fromJson(json["users"] ?? {}),
    gpsMaster: Address.fromJson(json["gpsMaster"] ?? {}),
    tripsheetview: Address.fromJson(json["tripsheetview"] ?? {}),
    commonapiconfiguration: Address.fromJson(json["commonapiconfiguration"] ?? {}),
    mapMaster: Address.fromJson(json["mapMaster"] ?? {}),
    fastagMaster: Address.fromJson(json["fastagMaster"] ?? {}),
    dieselMaster: Address.fromJson(json["dieselMaster"] ?? {}),
    zone: Address.fromJson(json["zone"] ?? {}),
    customerGroup: Address.fromJson(json["customer-group"] ?? {}),
    customerGroupCreate: Address.fromJson(json["customer-group-create"] ?? {}),
    customerGroupUpdate: Address.fromJson(json["customer-group-update"] ?? {}),
    location: Address.fromJson(json["location"] ?? {}),
    branch: Address.fromJson(json["branch"] ?? {}),
    product: Address.fromJson(json["product"] ?? {}),
    combomaster: Address.fromJson(json["combomaster"] ?? {}),
    ledgers: Address.fromJson(json["ledgers"] ?? {}),
    invoicemaster: Address.fromJson(json["invoicemaster"] ?? {}),
    taxMaster: Address.fromJson(json["taxMaster"] ?? {}),
    hsnMaster: Address.fromJson(json["hsnMaster"] ?? {}),
    customersWalkIn: Address.fromJson(json["customers-walk-in"] ?? {}),
    agent: Address.fromJson(json["agent"] ?? {}),
    updateAgent: Address.fromJson(json["update-agent"] ?? {}),
    locationHierarchyUpdate: Address.fromJson(json["locationHierarchyUpdate"] ?? {}),
    locationHierarchyCreate: Address.fromJson(json["locationHierarchyCreate"] ?? {}),
    vendor: Address.fromJson(json["vendor"] ?? {}),
    vendorCreate: Address.fromJson(json["vendor-create"] ?? {}),
    locationHierarchy: Address.fromJson(json["locationHierarchy"] ?? {}),
    vendorUpdate: Address.fromJson(json["vendor-update"] ?? {}),
    stock: Address.fromJson(json["stock"] ?? {}),
    address: Address.fromJson(json["address"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "commonoperations": commonoperations.toJson(),
    "cities": cities.toJson(),
    "pin": pin.toJson(),
    "users": users.toJson(),
    "gpsMaster": gpsMaster.toJson(),
    "tripsheetview": tripsheetview.toJson(),
    "commonapiconfiguration": commonapiconfiguration.toJson(),
    "mapMaster": mapMaster.toJson(),
    "fastagMaster": fastagMaster.toJson(),
    "dieselMaster": dieselMaster.toJson(),
    "zone": zone.toJson(),
    "customer-group": customerGroup.toJson(),
    "customer-group-create": customerGroupCreate.toJson(),
    "customer-group-update": customerGroupUpdate.toJson(),
    "location": location.toJson(),
    "branch": branch.toJson(),
    "product": product.toJson(),
    "combomaster": combomaster.toJson(),
    "ledgers": ledgers.toJson(),
    "invoicemaster": invoicemaster.toJson(),
    "taxMaster": taxMaster.toJson(),
    "hsnMaster": hsnMaster.toJson(),
    "customers-walk-in": customersWalkIn.toJson(),
    "agent": agent.toJson(),
    "update-agent": updateAgent.toJson(),
    "locationHierarchyUpdate": locationHierarchyUpdate.toJson(),
    "locationHierarchyCreate": locationHierarchyCreate.toJson(),
    "vendor": vendor.toJson(),
    "vendor-create": vendorCreate.toJson(),
    "locationHierarchy": locationHierarchy.toJson(),
    "vendor-update": vendorUpdate.toJson(),
    "stock": stock.toJson(),
    "address": address.toJson(),
  };
}

class Address {
  final String id;
  final int rowLevel;
  final String name;
  final PermissionClass operations;
  final String identifier;
  final PermissionClass permission;
  final AddressChildData childData;

  Address({
    required this.id,
    required this.rowLevel,
    required this.name,
    required this.operations,
    required this.identifier,
    required this.permission,
    required this.childData,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] ?? "",
    rowLevel: json["row_level"] ?? 0,
    name: json["name"] ?? "",
    operations: PermissionClass.fromJson(json["operations"] ?? {}),
    identifier: json["identifier"] ?? "",
    permission: PermissionClass.fromJson(json["permission"] ?? {}),
    childData: AddressChildData.fromJson(json["childData"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "row_level": rowLevel,
    "name": name,
    "operations": operations.toJson(),
    "identifier": identifier,
    "permission": permission.toJson(),
    "childData": childData.toJson(),
  };
}

class AddressChildData {
  AddressChildData();

  factory AddressChildData.fromJson(Map<String, dynamic> json) => AddressChildData();

  Map<String, dynamic> toJson() => {};
}

class PermissionClass {
  final bool view;
  final bool create;
  final bool delete;
  final bool operationsExport;
  final bool operationsImport;
  final bool update;

  PermissionClass({
    required this.view,
    required this.create,
    required this.delete,
    required this.operationsExport,
    required this.operationsImport,
    required this.update,
  });

  factory PermissionClass.fromJson(Map<String, dynamic> json) => PermissionClass(
    view: json["view"] ?? false,
    create: json["create"] ?? false,
    delete: json["delete"] ?? false,
    operationsExport: json["export"] ?? false,
    operationsImport: json["import"] ?? false,
    update: json["update"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "view": view,
    "create": create,
    "delete": delete,
    "export": operationsExport,
    "import": operationsImport,
    "update": update,
  };
}

class RolePermissionOperations {
  final String id;
  final int rowLevel;
  final String name;
  final PermissionClass operations;
  final String identifier;
  final PermissionClass permission;
  final OperationsChildData childData;

  RolePermissionOperations({
    required this.id,
    required this.rowLevel,
    required this.name,
    required this.operations,
    required this.identifier,
    required this.permission,
    required this.childData,
  });

  factory RolePermissionOperations.fromJson(Map<String, dynamic> json) => RolePermissionOperations(
    id: json["id"] ?? "",
    rowLevel: json["row_level"] ?? 0,
    name: json["name"] ?? "",
    operations: PermissionClass.fromJson(json["operations"] ?? {}),
    identifier: json["identifier"] ?? "",
    permission: PermissionClass.fromJson(json["permission"] ?? {}),
    childData: OperationsChildData.fromJson(json["childData"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "row_level": rowLevel,
    "name": name,
    "operations": operations.toJson(),
    "identifier": identifier,
    "permission": permission.toJson(),
    "childData": childData.toJson(),
  };
}

class OperationsChildData {
  final Address customers;
  final Address drivers;
  final Address fleet;
  final Address vehicle;
  final Address trip;
  final Address lrEntry;
  final Address vehiclereport;
  final Address lrEntryList;
  final Address driverreport;
  final Address lsEntryList;
  final Address lsEntry;
  final Address billingEntry;
  final Address billingEntryList;
  final Address opportunity;
  final Address quotation;
  final Address invoices;

  OperationsChildData({
    required this.customers,
    required this.drivers,
    required this.fleet,
    required this.vehicle,
    required this.trip,
    required this.lrEntry,
    required this.vehiclereport,
    required this.lrEntryList,
    required this.driverreport,
    required this.lsEntryList,
    required this.lsEntry,
    required this.billingEntry,
    required this.billingEntryList,
    required this.opportunity,
    required this.quotation,
    required this.invoices,
  });

  factory OperationsChildData.fromJson(Map<String, dynamic> json) => OperationsChildData(
    customers: Address.fromJson(json["customers"] ?? {}),
    drivers: Address.fromJson(json["drivers"] ?? {}),
    fleet: Address.fromJson(json["fleet"] ?? {}),
    vehicle: Address.fromJson(json["vehicle"] ?? {}),
    trip: Address.fromJson(json["trip"] ?? {}),
    lrEntry: Address.fromJson(json["lrEntry"] ?? {}),
    vehiclereport: Address.fromJson(json["vehiclereport"] ?? {}),
    lrEntryList: Address.fromJson(json["lrEntryList"] ?? {}),
    driverreport: Address.fromJson(json["driverreport"] ?? {}),
    lsEntryList: Address.fromJson(json["lsEntryList"] ?? {}),
    lsEntry: Address.fromJson(json["lsEntry"] ?? {}),
    billingEntry: Address.fromJson(json["billingEntry"] ?? {}),
    billingEntryList: Address.fromJson(json["billingEntryList"] ?? {}),
    opportunity: Address.fromJson(json["opportunity"] ?? {}),
    quotation: Address.fromJson(json["quotation"] ?? {}),
    invoices: Address.fromJson(json["invoices"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "customers": customers.toJson(),
    "drivers": drivers.toJson(),
    "fleet": fleet.toJson(),
    "vehicle": vehicle.toJson(),
    "trip": trip.toJson(),
    "lrEntry": lrEntry.toJson(),
    "vehiclereport": vehiclereport.toJson(),
    "lrEntryList": lrEntryList.toJson(),
    "driverreport": driverreport.toJson(),
    "lsEntryList": lsEntryList.toJson(),
    "lsEntry": lsEntry.toJson(),
    "billingEntry": billingEntry.toJson(),
    "billingEntryList": billingEntryList.toJson(),
    "opportunity": opportunity.toJson(),
    "quotation": quotation.toJson(),
    "invoices": invoices.toJson(),
  };
}

class Purchase {
  final String id;
  final int rowLevel;
  final String name;
  final PermissionClass operations;
  final String identifier;
  final PermissionClass permission;
  final PurchaseChildData childData;

  Purchase({
    required this.id,
    required this.rowLevel,
    required this.name,
    required this.operations,
    required this.identifier,
    required this.permission,
    required this.childData,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    id: json["id"] ?? "",
    rowLevel: json["row_level"] ?? 0,
    name: json["name"] ?? "",
    operations: PermissionClass.fromJson(json["operations"] ?? {}),
    identifier: json["identifier"] ?? "",
    permission: PermissionClass.fromJson(json["permission"] ?? {}),
    childData: PurchaseChildData.fromJson(json["childData"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "row_level": rowLevel,
    "name": name,
    "operations": operations.toJson(),
    "identifier": identifier,
    "permission": permission.toJson(),
    "childData": childData.toJson(),
  };
}

class PurchaseChildData {
  final Address mrm;
  final Address po;
  final Address grn;

  PurchaseChildData({required this.mrm, required this.po, required this.grn});

  factory PurchaseChildData.fromJson(Map<String, dynamic> json) =>
      PurchaseChildData(mrm: Address.fromJson(json["mrm"] ?? {}), po: Address.fromJson(json["po"] ?? {}), grn: Address.fromJson(json["grn"] ?? {}));

  Map<String, dynamic> toJson() => {"mrm": mrm.toJson(), "po": po.toJson(), "grn": grn.toJson()};
}

class TenantId {
  final String id;
  final String orgName;
  final String ownerFirstName;
  final String ownerLastName;
  final String email;
  final String orgId;
  final String dbName;
  final String subDomain;
  final String contact;
  final String address;
  final String city;
  final String state;
  final String pin;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final dynamic deletedAt;
  final dynamic gpsApiAccessKey;

  TenantId({
    required this.id,
    required this.orgName,
    required this.ownerFirstName,
    required this.ownerLastName,
    required this.email,
    required this.orgId,
    required this.dbName,
    required this.subDomain,
    required this.contact,
    required this.address,
    required this.city,
    required this.state,
    required this.pin,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.deletedAt,
    required this.gpsApiAccessKey,
  });

  factory TenantId.fromJson(Map<String, dynamic> json) => TenantId(
    id: json["id"] ?? "",
    orgName: json["org_name"] ?? "",
    ownerFirstName: json["owner_first_name"] ?? "",
    ownerLastName: json["owner_last_name"] ?? "",
    email: json["email"] ?? "",
    orgId: json["org_id"] ?? "",
    dbName: json["db_name"] ?? "",
    subDomain: json["sub_domain"] ?? "",
    contact: json["contact"] ?? "",
    address: json["address"] ?? "",
    city: json["city"] ?? "",
    state: json["state"] ?? "",
    pin: json["pin"] ?? "",
    isActive: json["is_active"] ?? false,
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"] ?? "",
    gpsApiAccessKey: json["gps_api_access_key"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "org_name": orgName,
    "owner_first_name": ownerFirstName,
    "owner_last_name": ownerLastName,
    "email": email,
    "org_id": orgId,
    "db_name": dbName,
    "sub_domain": subDomain,
    "contact": contact,
    "address": address,
    "city": city,
    "state": state,
    "pin": pin,
    "is_active": isActive,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "gps_api_access_key": gpsApiAccessKey,
  };
}
