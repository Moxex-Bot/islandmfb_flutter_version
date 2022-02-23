// helper functions
import 'dart:convert';
import 'package:islandmfb_flutter_version/requests/request_settings.dart';
import 'package:http/http.dart' as http;

String xformurlencoder(Map<dynamic, dynamic> bodyFields) {
  String encodedStr = "";

  for (String field in bodyFields.keys) {
    if (encodedStr.isNotEmpty) {
      encodedStr += "&";
    }
    encodedStr += (field + "=" + bodyFields[field]);
  }

  return encodedStr;
}

// requests
Future loginUser(String username, String password) async {
  Map loginInfo = {
    "username": username,
    "password": password,
    "grant_type": passwordGrantType,
    "client_id": customClientId
  };

  String body = xformurlencoder(loginInfo);

  String uri = keycloakBaseUrl +
      "/auth/realms/" +
      customRealm +
      "/protocol/openid-connect/token";

  return await http
      .post(Uri.parse(uri),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: body)
      .then(
    (value) {
      return json.decode(value.body);
    },
  );
}

Future getUser(String token) async {
  String uriString = keycloakBaseUrl +
      "/auth/realms/" +
      customRealm +
      "/protocol/openid-connect/userinfo";
  return await http.get(Uri.parse(uriString), headers: {
    "Authorization": "Bearer " + token,
    "Accept": "application/json"
  }).then(
    (value) {
      print(json.decode(value.body));
      return json.decode(value.body);
    },
  );
}

Future getAdminToken() async {
  const adminTokenInfo = {
    "client_secret": clientSecret,
    "grant_type": clientCredientialGrantType,
    "client_id": adminClientId,
  };

  String body = xformurlencoder(adminTokenInfo);
  String urlString = keycloakBaseUrl +
      "/auth/realms/" +
      customRealm +
      "/protocol/openid-connect/token";

  return http
      .post(Uri.parse(urlString),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: body)
      .then(
        (value) => json.decode(value.body),
      );
}

Future registerUser(
  String firstName,
  String lastName,
  String email,
  String username,
  String password,
  String adminToken,
) async {
  Map<String, dynamic> body = {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "username": username,
    "enabled": true,
    "emailVerified": true,
    "credentials": [
      {"value": password, "type": "password", "temporary": false}
    ]
  };

  String uriString =
      keycloakBaseUrl + "/auth/admin/realms/" + customRealm + "/users";

  return http
      .post(Uri.parse(uriString),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + adminToken
          },
          body: json.encode(body))
      .then(
    (value) {
      if (value.statusCode == 201) {
        return {"success": true, "msg": "Account Created"};
      } else {
        return {"success": false, "msg": json.decode(value.body)};
      }
    },
  );
}

Future logoutUser(String refreshToken) async {
  Map<String, String> logoutInfo = {
    "client_id": customClientId,
    "refresh_token": refreshToken,
  };

  String body = xformurlencoder(logoutInfo);
  String urlString = keycloakBaseUrl +
      "/auth/realms/" +
      customRealm +
      "/protocol/openid-connect/logout";

  return await http
      .post(
    Uri.parse(urlString),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: body,
  )
      .then(
    (value) {
      if (value.statusCode == 204) {
        return {"sucess": true, "msg": "User Logged Out"};
      } else {
        return {"success": false, "msg": json.decode(value.body)};
      }
    },
  );
}

void main() async {
  var tokenInfo = await loginUser("aji", "test1234");
  print(tokenInfo);
  var user = await getUser(tokenInfo["access_token"]);

  print(await logoutUser(tokenInfo["refresh_token"]));
  // var adminToken = await getAdminToken();
  // print(adminToken);
  // print(await registerUser("Anjy", "Olamide", "email@gsd.com", "aji",
  //     "test1234", adminToken["access_token"]));
}
