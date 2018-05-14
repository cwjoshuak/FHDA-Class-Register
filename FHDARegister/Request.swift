//
//  API.swift
//  FHDA Class Register
//
//  Created by Joshua Kuan on 11/05/2018.
//  Copyright © 2018 Joshua Kuan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestController {
    static let shared = RequestController()
    
    private init() { }
    
    // MARK: Functions
    
    /**
     Actual HTTP Request
     
     - parameter url: URL to request
     - parameter params: Optional URL Query Parameters to send
     - parameter completion: Returns JSON data
     */
    
    func request(
        _ endpoint : Endpoint,
        params: [String : String]? = nil,
        then completion: @escaping ([String]?, Dept?, [Course]?) -> ()
    ) {
        let endpointInfo = endpoint.httpInfo
        var urlString = "https://floof.li\(endpointInfo.url)"
        var numParams = 0
        if let params = params {
            urlString += "?"
            urlString += params.map(
                { key, value in "\(key)=\(value)" }
                ).joined(separator: "&")
            numParams = params.count
        }

        Alamofire.request(urlString).validate().responseJSON { (response) in
            if let error = response.result.error {
                print(error)
                return
            }
            
            switch(endpoint) {
            case Endpoint.courseList:
                let courseList = response.result.value as! String
                let array = courseList.components(separatedBy: ", ")
                completion(array, nil, nil)
                return
            case Endpoint.getSingle:
                let json = JSON(response.result.value!)

                if(numParams == 1) {
                    var dept = Dept(params!["dept"]!)
                    
                    for (index, sections) in json {
                        var count = 0
                        for (section, courses):(String, JSON) in sections {
                            let sec = Section(section)
                            dept.addSection(sec)
                            for(course, courseData):(String, JSON) in courses {
                                for(numClass, cData):(String, JSON) in courseData {
                                    dept.sections[count].addCourse(Course(cData))
                                    print(dept.sections[count].courses)
                                }
                            }
                            count += 1
                        }
                    }
                    completion(nil, dept, nil)
                    return
                }
            case Endpoint.getURLs:
                completion(nil, nil, nil)
            case Endpoint.postBatch:
                completion(nil, nil, nil)
                
            }
            
        }
        

        print(urlString)
    }
}
