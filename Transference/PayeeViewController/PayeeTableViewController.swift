//
//  PayeeTableViewController.swift
//  Transference
//
//  Created by Ravi Prakash on 25/6/2018.
//  Copyright © 2018 xpd54. All rights reserved.
//

import UIKit

class PayeeTableViewController: UITableViewController {
    var listOfPayee = [NSDictionary]()
    override func viewDidLoad() {
        self.clearsSelectionOnViewWillAppear = true
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        self.tableView.backgroundColor = cellBackgroundColor
        self.title = Label.SelectPayee
        self.tableView.separatorColor = .black
        setBarButton()
        updatePayeeList()
    }

    func setBarButton() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(payScreen))
        self.navigationItem.rightBarButtonItem = barButton
    }

    @objc func payScreen() {
        let selectedRow = self.tableView.indexPathForSelectedRow
        if selectedRow != nil {
            let payViewController = PayViewController()
            DataController.fetchCurrentBalance { (currentBalance) in
                if currentBalance != nil {
                    payViewController.balance = currentBalance!
                    let user = self.listOfPayee[(selectedRow?.row)!]
                    let name = user.object(forKey: Label.NameKey) as! String
                    let email = user.object(forKey: Label.EmailKey) as! String
                    payViewController.balance = currentBalance!
                    payViewController.payeeName = name
                    payViewController.payeeEmail = email
                    // remove checkmark from cell before moving to pay screen
                    self.tableView.cellForRow(at: selectedRow!)?.accessoryType = .none
                    self.navigationController?.pushViewController(payViewController, animated: true)
                }
            }
        }
    }

    func updatePayeeList() {
        DataController.fetchAllPayee { (listOfPayee) in
            if listOfPayee != nil {
                self.listOfPayee = listOfPayee!
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfPayee.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PayeeTableViewCell(style: .default, reuseIdentifier: "com.payee.reuse")
        let user = listOfPayee[indexPath.row]
        let name = user.object(forKey: Label.NameKey) as! String
        let email = user.object(forKey: Label.EmailKey) as! String
        cell.textLabel?.text = "\(name)   <\(email)>"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
