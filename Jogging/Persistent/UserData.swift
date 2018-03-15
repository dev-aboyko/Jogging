//
//  UserData.swift
//

import UIKit
import SwiftyJSON

class UserData {

    static var token: String? { get { return defaults.string(forKey: tokenKey) }
                                set { defaults.set(newValue, forKey: tokenKey) }   }
    
    static var refreshToken: String? { get { return defaults.string(forKey: refreshTokenKey) }
                                       set { defaults.set(newValue, forKey: refreshTokenKey) }   }
    
    static var userRole: String? {  get {return defaults.string(forKey: userRoleKey) }
                                    set { defaults.set(newValue, forKey: userRoleKey ) } }
    
    static var isAdmin: Bool { return userRole == "admin" }
    
    static var expiresAt: Date? {   get { return defaults.value(forKey: expiresAtKey) as? Date }
                                    set { defaults.set(newValue, forKey: expiresAtKey) } }
    
    static var userId: String? { get { return defaults.string(forKey: userIdKey) }
                                 set { defaults.set(newValue, forKey: userIdKey) }   }
    
    static var email: String? { get { return defaults.string(forKey: emailKey) }
                                set { defaults.set(newValue, forKey: emailKey)}  }
    
    static var currentUser: (user: String, email: String) { return (user: userId!, email: email!) }
    
    static func clear() {
        token = nil
        refreshToken = nil
        userRole = nil
        expiresAt = nil
        userId = nil
    }
    
    private static let emailKey = "email"
    private static let userIdKey = "user id"
    private static let tokenKey = "token"
    private static let refreshTokenKey = "refresh token"
    private static let expiresAtKey = "expires at"
    private static let userRoleKey = "user role"

    private static var defaults: UserDefaults { return UserDefaults.standard }

    private init() {}

}
