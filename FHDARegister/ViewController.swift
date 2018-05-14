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
            // TODO: implement coursePicker
            let deptRow = deptPicker.selectedRow(inComponent: 0)
            if component == 0 {
                // section component
                return (deptRow < deptArr.count) ? deptArr[deptRow].sections.count : 0
            } else if component == 1 {
                // courses component
                let secRow = pickerView.selectedRow(inComponent: 0)
                return (deptRow < deptArr.count && secRow < deptArr[deptRow].sections.count) ? deptArr[deptRow].sections[secRow].courses.count : 0
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
            // TODO: implement coursePicker
            let dRow = deptPicker.selectedRow(inComponent: 0)
            if component == 0 {
                return deptArr[dRow].sections[row].sectionNum
            } else if component == 1 {
                let sectionRow = coursePicker.selectedRow(inComponent: 0)
                return deptArr[dRow].sections[sectionRow].courses[row].cid
            }
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == campusPicker {
            print(row)
            switch(row) {
            case 0:
                selectedCampus = Course.Campus.fh
            case 1:
                selectedCampus = Course.Campus.da
            default:
                break
            }
            populateCourses(endpoint: .courseList(selectedCampus!.rawValue))
        } else if pickerView == deptPicker {
            // assumes already populated sections (and courses)
            let params = ["dept" : deptArr[row].name]
            populateCourses(endpoint: .getSingle(selectedCampus!.rawValue), params: params)
        } else if pickerView == coursePicker {
            if component == 0 {
                // section
                pickerView.reloadComponent(1)
            } else if component == 1 {
                textView.text = ""
                let dRow = deptPicker.selectedRow(inComponent: 0)
                let sRow = pickerView.selectedRow(inComponent: 0)
                //let temp = deptArr[dRow].sections[sRow].courses[row]
                //textView.text! += temp as CustomStringConvertible as! String
            }
        }
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
                    let index = self.deptPicker.selectedRow(inComponent: 0)
                    self.deptArr[index] = dept
                }
                self.coursePicker.reloadAllComponents()
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
                self.deptPicker.reloadAllComponents()
            }
        }
    }
}

