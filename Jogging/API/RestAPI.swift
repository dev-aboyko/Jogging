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
    
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func processResponse(_ response: DefaultDataResponse) {
        if let data = response.data {
            self.checkReceived(data)
        } else {
            self.processFail(message: response.error?.localizedDescription ?? "")
        }
    }
    
    private func checkReceived(_ data: Data) {
        guard let json = try? JSON(data: data) else {
            processFail(message: "decoding json")
            Log.error("data: \(data)")
            return
        }
        if let errorMessage = json["error"]["message"].string {
            processFail(message: errorMessage)
            return
        }
        Log.message("Received json: \(json)")
        isSuccessfull = true
        self.json = json
    }
    
    private func processFail(message: String) {
        Log.error("process fail \(message)")
        statusDescription = message
    }
    
}

class RestAPIpost: RestAPI {
    
    private let parameters: Dictionary<String, Any>

    init(urlString: String, parameters: Dictionary<String, Any>) {
        self.parameters = parameters
        super.init(urlString: urlString)
    }

    func connect(_ completion: @escaping () -> Void) {
        let contentType: HTTPHeaders = ["Content-Type" : "application/json"]
        guard let url = URL(string: urlString) else {
            Log.error("creating URL for request")
            return
        }
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: contentType).response { response in
            self.processResponse(response)
            completion()
        }
    }
    
}

class RestAPIget: RestAPI {
    
    func connect(_ completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else {
            Log.error("creating URL for GET request")
            return
        }
        Alamofire.request(url).response { (dataResponse) in
            self.processResponse(dataResponse)
            completion()
        }
    }

}

class RestAPIdelete: RestAPI {
    
    func connect(_ completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else {
            Log.error("creating URL for DELETE request")
            return
        }
        Alamofire.request(url, method:.delete).response { (dataResponse) in
            Log.message("Data response: \(dataResponse)")
            self.statusDescription = dataResponse.error?.localizedDescription
            completion()
        }
    }
    
}
