//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 19/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    let idCell = "studentsCell"
    let viewControllerID = "addStudentVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addStudent(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func reloadStudents(_ sender: UIBarButtonItem) {
        requestStudents()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserSession.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath)
        let student = UserSession.students[indexPath.row]
        cell.textLabel?.text = student.firstName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaURL = UserSession.students[indexPath.row].mediaURL
        guard let url = URL(string: mediaURL ?? "") else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    func requestStudents() {
        
        func sucess() {
            tableView.reloadData()
        }
        
        func fail(msg: String) {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
        Requester().getStudents(limit: 100, crescent: false, sucess: sucess, fail: fail)
    }
}
