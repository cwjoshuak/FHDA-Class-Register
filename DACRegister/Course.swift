//
//  Course.swift
//  DACRegister
//
//  Created by Joshua Kuan on 11/05/2018.
//  Copyright © 2018 Joshua Kuan. All rights reserved.
//

import Foundation

public struct Course : Codable {
    enum Campus : String, Codable {
        case fh
        case da
    }
    enum Days : String, Codable {
        case M
        case T
        case W
        case Th
        case F
        case S
        case Su
    }
    /*
    CRN        | Course Number
    course     | Course ID (format: [F0*][ID][Section ID][WYH]) see note
    desc       | Short-form course description
    campus     | Campus the section is held at
    days       | Day(s) the section is held on (M, T, W, Th, F, S, U)
    instructor | Professor for the section
    room       | Room the section is held at
    time       | Time for the section
    start      | First date for the section
    end        | Last date for the course
    units      | Number of course units
    seats      | Seats left in the course
    wait_cap   | Waitlist capacity
    wait_seats | Waitlist slots left in the course
 */
    var crn : Int
    var cid : Int
    var desc : String
    var campus : Campus
    var days : [Days]
    var instructor : String
    var room : String?
    var status : String
    var time : String?
    var startDate : String?
    var endDate : String?
    var units : Double
    var seats : Int
    var waitCap : Int
    var waitSeats : Int
    

}
