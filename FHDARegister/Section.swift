//
//  Section.swift
//  FHDA Class Register
//
//  Created by Joshua Kuan on 12/05/2018.
//  Copyright © 2018 Joshua Kuan. All rights reserved.
//

import Foundation

public struct Section {
    var courses = [Course]()
    var sectionNum : String
    mutating func addCourse(_ course: Course) {
        self.courses.append(course)
    }
    init(_ secNum: String) {
        sectionNum = secNum
    }
}
