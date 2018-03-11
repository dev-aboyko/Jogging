//
//  API.swift
//  Jogging
//
//  Created by Alexey Boyko on 11/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation

class API {
    
    static func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        let apiLogin = APILogin(email: email, password: password)
        apiLogin.connect {
            if apiLogin.isSuccessfull {
                getUserRole(apiLogin: apiLogin, completion: completion)
            } else {
                completion(apiLogin.statusDescription ?? "Login API error 1")
            }
        }
    }
    
    private static func getUserRole(apiLogin: APILogin, completion: @escaping (String?) -> Void) {
        guard
            let token = apiLogin.token,
            let userId = apiLogin.userId else {
                completion("Login API error 2")
                return
        }
        let apiGetUserRole = APIGetUserRole(userId: userId, token: token)
        apiGetUserRole.connect {
            var errorMessage: String?
            if apiGetUserRole.isSuccessfull {
                errorMessage = storeLoginInfo(apiLogin: apiLogin, apiGetUserRole: apiGetUserRole)
            } else {
                errorMessage = apiGetUserRole.statusDescription ?? "Get User Role API error"
            }
            completion(errorMessage)
        }
    }
    
    private static func storeLoginInfo(apiLogin: APILogin, apiGetUserRole: APIGetUserRole) -> String? {
        guard
            let token = apiLogin.token,
            let refreshToken = apiLogin.refreshToken,
            let expiresIn = apiLogin.expiresIn,
            let userRole = apiGetUserRole.userRole else {
                return "getting user info"
        }
        UserData.token = token
        UserData.refreshToken = refreshToken
        UserData.userRole = userRole
        UserData.expiresAt = Date().addingTimeInterval(expiresIn)
        return nil
    }
    
}
