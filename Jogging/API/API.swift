//
//  API.swift
//  Jogging
//
//  Created by Alexey Boyko on 11/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation
import SwiftyJSON

class API {
    
    static func createUser(email: String, password: String, role: String, completion: @escaping (String?) -> Void) {
        let apiCreateUser = APICreateUser(email: email, password: password)
        apiCreateUser.connect {
            if apiCreateUser.isSuccessfull {
                createUserInfo(userId: apiCreateUser.userId!, email: email, role: role, completion: completion)
            } else {
                completion(apiCreateUser.statusDescription ?? "")
            }
        }
    }
    
    static func createUserInfo(userId: String, email: String, role: String, completion: @escaping (String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(errorMessage)
                return
            }
            let apiCreateUserInfo = APICreateUserInfo(userId: userId, email: email, role: role, token: UserData.token!)
            apiCreateUserInfo.connect {
                if apiCreateUserInfo.isSuccessfull {
                    completion(nil)
                } else {
                    completion(apiCreateUserInfo.statusDescription ?? "")
                }
            }
        }
    }
    
    static func deleteUserInfo(userId: String, completion: @escaping (String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(errorMessage)
                return
            }
            let api = APIDeleteUserInfo(userId: userId, token: UserData.token!)
            api.connect {
                if api.isSuccessfull {
                    completion(nil)
                } else {
                    completion(api.statusDescription ?? "")
                }
            }
        }
    }
    
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
                errorMessage = "User not found"
            }
            completion(errorMessage)
        }
    }
    
    private static func storeLoginInfo(apiLogin: APILogin, apiGetUserRole: APIGetUserRole) -> String? {
        guard
            let token = apiLogin.token,
            let refreshToken = apiLogin.refreshToken,
            let expiresIn = apiLogin.expiresIn,
            let userId = apiLogin.userId,
            let email = apiGetUserRole.email,
            let userRole = apiGetUserRole.userRole else {
                return "getting user info"
        }
        UserData.userId = userId
        UserData.token = token
        UserData.refreshToken = refreshToken
        UserData.email = email
        UserData.userRole = userRole
        UserData.expiresAt = Date().addingTimeInterval(expiresIn)
        return nil
    }
    
    static func addEntry(userId: String, date: Date, time: Date, distance: Int, completion: @escaping (String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(errorMessage)
                return
            }
            let cal = Calendar.current
            let minutes = cal.component(.minute, from: time) + 60 * cal.component(.hour, from: time)
            let apiAddEntry = APIAddEntry(date: date.timeIntervalSince1970, minutes: minutes, distance: distance, userId: userId, token: UserData.token!)
            apiAddEntry.connect {
                if apiAddEntry.isSuccessfull {
                    completion(nil)
                } else {
                    completion(apiAddEntry.statusDescription ?? "")
                }
            }
        }
    }
    
    static func updateEntry(entry: String, userId: String, date: Date, time: Date, distance: Int, completion: @escaping (String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(errorMessage)
                return
            }
            let cal = Calendar.current
            let minutes = cal.component(.minute, from: time) + 60 * cal.component(.hour, from: time)
            let apiUpdateEntry = APIUpdateEntry(entry: entry, date: date.timeIntervalSince1970, minutes: minutes, distance: distance, userId: userId, token: UserData.token!)
            apiUpdateEntry.connect {
                if apiUpdateEntry.isSuccessfull {
                    completion(nil)
                } else {
                    completion(apiUpdateEntry.statusDescription ?? "")
                }
            }
        }
    }
    
    static func getEntries(completion: @escaping ([String : String]?, JSON?, String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(nil, nil, errorMessage)
                return
            }
            let admin = UserData.userRole == "admin"
            let apiGetEntries = admin ? APIGetEntries(token: UserData.token!) : APIGetEntries(userId: UserData.userId!, token: UserData.token!)
            apiGetEntries.connect {
                if apiGetEntries.isSuccessfull {
                    if admin {
                        getUsers(entries: apiGetEntries.json, completion: completion)
                    } else {
                        completion(nil, apiGetEntries.json, nil)
                    }
                } else {
                    completion(nil, nil, apiGetEntries.statusDescription ?? "")
                }
            }
        }
    }
    
    private static func getUsers(entries: JSON?, completion: @escaping ([String : String]?, JSON?, String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(nil, nil, errorMessage)
                return
            }
            let apiGetUsers = APIGetUsers(token: UserData.token!)
            apiGetUsers.connect {
                if apiGetUsers.isSuccessfull {
                    let allUsers = users(from: apiGetUsers.json!)
                    completion(allUsers, entries, nil)
                } else {
                    completion(nil, nil, apiGetUsers.statusDescription ?? "")
                }
            }
        }
    }
    
    private static func users(from json: JSON) -> [String : String] {
        var allUsers = [String : String]()
        for (user, info) in json {
            guard let email = info["email"].string else {
                Log.error("missing email for \(user)")
                continue
            }
            allUsers[user] = email
        }
        return allUsers
    }
    
    static func getMyEntries(completion: @escaping(JSON?, String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(nil, errorMessage)
                return
            }
            let apiGetEntries = APIGetEntries(userId: UserData.userId!, token: UserData.token!)
            apiGetEntries.connect {
                if apiGetEntries.isSuccessfull {
                    completion(apiGetEntries.json, nil)
                } else {
                    completion(nil, apiGetEntries.statusDescription ?? "")
                }
            }
        }
    }
    
    static func getUsers(completion: @escaping (JSON?, String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(nil, errorMessage)
                return
            }
            let apiGetUsers = APIGetUsers(token: UserData.token!)
            apiGetUsers.connect {
                if apiGetUsers.isSuccessfull {
                    completion(apiGetUsers.json, nil)
                } else {
                    completion(nil, apiGetUsers.statusDescription ?? "")
                }
            }
        }
    }
    
    static func deleteEntry(name: String, completion: @escaping (String?) -> Void) {
        refreshTokenIfNeeded { errorMessage in
            guard errorMessage == nil else {
                completion(errorMessage)
                return
            }
            let api = APIDeleteEntry(name: name, token: UserData.token!)
            api.connect {
                if api.isSuccessfull {
                    completion(nil)
                } else {
                    completion(api.statusDescription)
                }
            }
        }
    }
    
    private static func refreshTokenIfNeeded(completion: @escaping (String?) -> Void) {
        let minInterval: TimeInterval = 120 // seconds to token expiration
        guard
        let expires = UserData.expiresAt,
        let refreshToken = UserData.refreshToken else {
            Log.error("missing token expiration date or refresh token")
            completion(nil)
            return
        }
        let dif = expires.timeIntervalSince(Date())
        if dif > minInterval {
            completion(nil)
            return
        }
        let apiRefreshToken = APIRefreshToken(refreshToken: refreshToken)
        apiRefreshToken.connect {
            if apiRefreshToken.isSuccessfull {
                let errorMessage = storeRefreshToken(apiRefreshToken: apiRefreshToken)
                completion(errorMessage)
            } else {
                completion(apiRefreshToken.statusDescription ?? "")
            }
        }
    }
    
    private static func storeRefreshToken(apiRefreshToken: APIRefreshToken) -> String? {
        guard
            let token = apiRefreshToken.token,
            let refreshToken = apiRefreshToken.refreshToken,
            let expiresIn = apiRefreshToken.expiresIn else {
                return "parsing refresh token request"
        }
        UserData.token = token
        UserData.refreshToken = refreshToken
        UserData.expiresAt = Date().addingTimeInterval(expiresIn)
        return nil
    }
    
}
