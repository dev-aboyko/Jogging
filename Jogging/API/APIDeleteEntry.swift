//
//  APIDeleteEntry.swift
//  Jogging
//
//  Created by Alexey Boyko on 13/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class APIDeleteEntry: RestAPIdelete {

    init(name: String, token: String) {
        let urlString = "\(Config.baseURL)/entries/\(name).json?auth=\(token)"
        super.init(urlString: urlString)
    }
    
}
