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
    
    static func clear() {
        token = nil
        refreshToken = nil
    }
    
    private static let tokenKey = "token"
    private static let refreshTokenKey = "refresh token"
    private static let expiresAtKey = "expires at"

    private static var defaults: UserDefaults { return UserDefaults.standard }

    private init() {}

}
