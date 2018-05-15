//
//  Course.swift
//  FHDA Class Register
//
//  Created by Joshua Kuan on 11/05/2018.
//  Copyright © 2018 Joshua Kuan. All rights reserved.
//

import Foundation
import SwiftyJSON
public struct Course {
    
    // MARK: Properties
    enum Campus : String {
        case fh = "FH"
        case da = "DA"
        case fc = "FC"
        case bad = "DO"
        case bad1 = "FO"
    }
    
    enum Days : String {
        case M
        case T
        case W
        case Th
        case F
        case S
        case Su
        case TBA
    }

    /// Course Number
    var crn: Int
    
    /// Course ID (format: [F0***][ID][Section ID][WYZH]) see note
    var cid: String
    
    /// Short-form course description
    var desc: String
    
    /// Campus the section is held at
    var campus: Campus
    
    /// Day(s) the section is held on (M, T, W, Th, F, S, U)
    var days = [Days]()
    
    /// Professor for the section
    var instructor: String
    
    /// Room the section is held at
    var room: String
    
    /// Status of the course [Open, Waitlist]
    var status: String
    
    /// Start time to End time for the course
    var time: String
    
    /// First date for the course
    var startDate: String
    
    /// Last date for the course
    var endDate: String
    
    /// Number of course units
    var units: Double
    
    /// Seats left in the course
    var seats: Int
    
    /// Waitlist capacity
    var waitCap: Int
    
    /// Waitlist slots left in the course
    var waitSeats: Int
    
    // MARK: Initializer
    
    /**
     Creates a single course
     
     - parameter args: expected to contain
     crn, cid (as course), desc, campus, days, intsructor, room, status,
     time, startDate, endDate, units, seats, waitCap, waitSeats
     
     */

    init(_ args: JSON) {

        crn = args["CRN"].intValue
        cid = args["course"].stringValue
        desc = args["desc"].stringValue
        campus = Campus(rawValue: args["campus"].stringValue)!

        let regex = try! NSRegularExpression(pattern: "(Su)|(TBA)|(Th)|(M)|(W)|(F)|(T)|(S)")
        let result = regex.matches(in: args["days"].stringValue, range: NSRange(args["days"].stringValue.startIndex..., in: args["days"].stringValue)).map {
            String(args["days"].stringValue[Range($0.range, in: args["days"].stringValue)!])
        }
        for day in result {
            days.append(Course.Days(rawValue: day)!)
        }
        instructor = args["instructor"].stringValue
        room = args["room"].stringValue
        status = args["status"].stringValue
        time = args["time"].stringValue
        startDate = args["start"].stringValue
        endDate = args["end"].stringValue
        units = args["units"].doubleValue
        seats = args["seats"].intValue
        waitCap = args["wait_seats"].intValue
        waitSeats = args["wait_cap"].intValue

    }
}
extension Course : CustomStringConvertible{
    public var description: String {
        var temp = "\(cid) : \(crn) : \(campus)\n\n"
        temp += "Description: \(desc)\n"
        temp += "Instructor: \(instructor)\n"
        temp += "Room: \(room)\n"
        temp += "Time : \(time)\n"
        temp += "Start Date: \(startDate)\n"
        temp += "End Date: \(endDate)\n"
        temp += "Status: \(status)\n"
        temp += "Units: \(units)\n"
        temp += "Days: \(days)\n"
        temp += "Waitlist Capacity: \(waitCap)\n"
        temp += "Waitlist Seats: \(waitSeats)\n"
        return temp
    }
}
