class BKKAPI {
  // Fiok API
  static const token = BaseBKK.bkkFiok + EndpointsBKK.token;
  static const userInfo = BaseBKK.bkkFiok + EndpointsBKK.userInfo;
  static const authLogin = BaseBKK.bkkFiok + WebEndpointsBKK.authLogin;

  static const clientId = "futar-plusz-ios";
  static const userAgent = "BudapestGO/484 CFNetwork/1492.0.1 Darwin/23.3.0";

  // other things
  static const tickets = BaseBKK.bkkGoErtbe + EndpointsBKK.tickets;
  static const purchaseInfo = BaseBKK.bkkGoErtbe + EndpointsBKK.purchaseInfo;
  static const favorites = BaseBKK.bkkGo + EndpointsBKK.favorites;
  static const authSync = BaseBKK.bkkFiok + EndpointsBKK.authSync;
  static const notificationTopics =
      BaseBKK.bkkGo + EndpointsBKK.notificationTopics;
  static String faqUrl(String locale) =>
      "${BaseBKK.bkkMain}/$locale${WebEndpointsBKK.faq}";
}

class BaseBKK {
  static const bkkMain = "https://bkk.hu";
  static const bkkFiok = "https://fiok.bkk.hu/auth/realms/public";
  static const bkkGo = "https://go.bkk.hu/api";
  static const bkkGoErtbe = "https://ertbe.go.bkk.hu/api";
}

class EndpointsBKK {
  static const token =
      "/protocol/openid-connect/token"; // (POST -> login or refresh)
  static const revoke = "/auth-sync/logout"; // (GET -> logout)
  static const tokenToCode = "/auth-sync/token-to-code"; // (POST)
  static const authSync = "/auth-sync/account"; // (GET, with params)
  static const updateAttribute =
      "/attribute-updater/update-user-attribute"; // (POST)
  static const userInfo = "/protocol/openid-connect/userinfo";

  static const tickets = "/user-product-list-with-count"; // (GET)
  static const purchaseInfo = "/purchase-info"; // (GET)
  static const favorites =
      "/user/v1/favorites"; // (GET -> get them, PUT -> add to list or remove)
  static const notificationTopics =
      "/user/v1/notifications/topics"; // (GET -> get them, POST -> update them)
}

class WebEndpointsBKK {
  static const authLogin = "/protocol/openid-connect/auth";

  static const faq = "/frequently-asked-questions/budapestgo/?frame=1&app=prod";
}
