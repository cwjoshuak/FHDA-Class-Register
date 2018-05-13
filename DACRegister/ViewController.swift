//
//  ViewController.swift
//  DACRegister
//
//  Created by Joshua Kuan on 04/05/2018.
//  Copyright © 2018 Joshua Kuan. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var campusPicker: UIPickerView!
    @IBOutlet weak var deptPicker: UIPickerView!
    
    @IBOutlet weak var coursePicker: UIPickerView!
    var deptArr : [Dept] = []
    var courseArr : [Course] = []
    let shard = RequestController.shared
    var selectedCampus : Course.Campus?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == coursePicker {
            return 2 // only coursepicker has 2 components (section / course)
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == campusPicker {
            return 2
        } else if pickerView == deptPicker {
            return deptArr.count
        } else if pickerView == coursePicker {
            if component == 0 {
                // section component
                let row = deptPicker.selectedRow(inComponent: 0)
                return (row < deptArr.count) ? deptArr[row].sections.count : 0
            } else if component == 1 {
                // courses component
                return courseArr.count
            }
        }
        return 0 // shouldn't happen
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == campusPicker {
            switch(row) {
            case 0:
                return Course.Campus.fh.rawValue.uppercased()
            case 1:
                return Course.Campus.da.rawValue.uppercased()
            default:
                return nil
            }
        } else if pickerView == deptPicker {
            return deptArr[row].name
        } else if pickerView == coursePicker {
            let sectionRow = coursePicker.selectedRow(inComponent: 0)
            return courseArr[sectionRow].cid
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == campusPicker {
            switch(row) {
            case 0:
                selectedCampus = Course.Campus.fh
            case 1:
                selectedCampus = Course.Campus.da
            default:
                break
            }
            populateCourses(endpoint: .courseList(selectedCampus!.rawValue))
            updatePicker(picker: 1)
        } else if pickerView == deptPicker {
            // assumes already populated sections (and courses)
            
        }
        //populateCourses()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        selectedCampus = Course.Campus.fh
        campusPicker.dataSource = self
        campusPicker.delegate = self
        deptPicker.dataSource = self
        deptPicker.delegate = self
        coursePicker.dataSource = self
        coursePicker.delegate = self
        populateCourses(endpoint: .courseList(selectedCampus!.rawValue))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func populateCourses(endpoint: Endpoint, params: [String : String]? = nil) {
        textView.text = ""
        if let params = params {
            shard.request(endpoint, params: params) { (sections, dept, courses) in
                if let dept = dept {
                    self.textView.text! += "Dept: \(dept.name)\n"
                    for section in dept.sections {
                        self.textView.text! += "Section: \(section.sectionNum)\n"
                        for course in section.courses {
                            self.textView.text! += "Course: \(course.desc)\n\n"
                        }
                        self.textView.text! += "\n"
                    }
                    self.textView.text! += "\n\n"
                }
            }
        } else {
            // for courseList
            shard.request(endpoint) { (sections, dept, courses) in
                self.deptArr.removeAll()
                if let sections = sections {
                    // ambiguous but section here refers to all department sections
                    for section in sections {
                        self.deptArr.append(Dept(section))
                    }
                }
            }
            
        }
    }
    func updatePicker(picker: Int) {
        DispatchQueue.main.sync {
            switch(picker) {
            case 0:
                self.campusPicker.reloadAllComponents()
            case 1:
                self.deptPicker.reloadAllComponents()
            case 2:
                self.coursePicker.reloadAllComponents()
            default:
                break
            }
        }
    }
}

