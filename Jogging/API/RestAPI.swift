//
//  RestAPI.swift
//  Jogging
//
//  Created by Alexey Boyko on 10/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIStatus {
    var json: JSON?
    var isSuccessfull = false
    var statusDescription: String?
}

class RestAPI: APIStatus {
    
    private let urlString: String
    private let parameters: Dictionary<String, Any>
    private let method: HTTPMethod
    
    init(urlString: String, parameters: Dictionary<String, Any>, method: HTTPMethod) {
        self.urlString = urlString
        self.parameters = parameters
        self.method = method
    }
    
    func connect(processResponse: @escaping () -> Void) {
        let contentType: HTTPHeaders = ["Content-Type" : "application/json"]
        guard let url = URL(string: urlString) else {
            Log.error("creating URL for authentication")
            return
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: contentType).response { response in
            if let data = response.data {
                self.checkReceived(data)
            } else {
                self.processFail(message: response.error?.localizedDescription ?? "")
            }
            processResponse()
        }
    }
    
    private func checkReceived(_ data: Data) {
        guard let json = try? JSON(data: data) else {
            processFail(message: "decoding json")
            return
        }
        if let errorMessage = json["error"]["message"].string {
            processFail(message: errorMessage)
            return
        }
        isSuccessfull = true
        self.json = json
    }
    
    private func processFail(message: String) {
        Log.error("process fail \(message)")
        statusDescription = message
    }
    
}
