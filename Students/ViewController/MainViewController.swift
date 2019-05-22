//
//  MainViewController.swift
//  Students
//
//  Created by Stephanie Bowles on 5/21/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: Outlets & Properties
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    private let studentController = StudentController()
   
    private var  studentTableViewController: StudentsTableViewController! {
        didSet {
            self.updateDataSource()
        }
    }
    private var students: [Student] = [] {
        didSet {
            self.updateDataSource()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentController.loadFromPersistentStore { (students, error) in
            if let error = error {
                print ("there was an error loading students \(error)")
                return
            }
            DispatchQueue.main.async {
                self.students = students ?? []
            }
            
        }

        // Do any additional setup after loading the view.
    }
    // MARK: IB Actions and Methods
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        self.updateDataSource()
    }
    
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        self.updateDataSource()
    }
    
    
    private func updateDataSource() {
        var sortedAndFilteredStudents : [Student]
        
        switch self.filterSegmentedControl.selectedSegmentIndex {
        case 1: //filter for iOS
//            sortedAndFilteredStudents = self.students.filter({ (student) -> Bool in
//                return student.course == "iOS"
//            })
            
            sortedAndFilteredStudents = self.students.filter {$0.course == "iOS"}
        case 2:
            sortedAndFilteredStudents = self.students.filter {$0.course == "Web"}
        case 3:
            sortedAndFilteredStudents = self.students.filter {$0.course == "UX"}
        default:
            sortedAndFilteredStudents = self.students
            
        }
        
        if self.sortSegmentedControl.selectedSegmentIndex == 0 {
            sortedAndFilteredStudents = sortedAndFilteredStudents.sorted { $0.firstName < $1.firstName }
           
        } else  {
            sortedAndFilteredStudents = sortedAndFilteredStudents.sorted { $0.lastName < $1.lastName}
        }  //can't visualize this
        self.studentTableViewController.students = sortedAndFilteredStudents
            
    }
    
    
    
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentListEmbedSegue" {
            self.studentTableViewController =  segue.destination as? StudentsTableViewController
        }
    }
 

}
