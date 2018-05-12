//
//  Endpoint.swift
//  DACRegister
//
//  Created by Joshua Kuan on 11/05/2018.
//  Copyright © 2018 Joshua Kuan. All rights reserved.
//

import Foundation
import Alamofire

enum Endpoint {
    case courseList(String)
    
    case getSingle(String)
    
    case postBatch(String)
}
typealias EndpointInfo = (method: Alamofire.HTTPMethod, url: String)

extension Endpoint {
    var httpInfo : EndpointInfo {
        switch self {
        case let .courseList(campus):
            return (Alamofire.HTTPMethod.get, "/\(campus)/list")
        case let .getSingle(campus):
            return (Alamofire.HTTPMethod.get, "/\(campus)/single")
        case let .postBatch(campus):
            return (Alamofire.HTTPMethod.post, "/\(campus)/batch")
        }
    }
}
