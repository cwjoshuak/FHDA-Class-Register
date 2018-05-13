//
//  Dept.swift
//  
//
//  Created by Joshua Kuan on 12/05/2018.
//

import Foundation

public struct Dept {
    var sections = [Section]()
    let name : String
    mutating func addSection(_ section: Section) {
        self.sections.append(section)
    }
    init(_ name: String) {
        self.name = name
    }
}
