//
//  AddPayeeViewController.swift
//  Transference
//
//  Created by Ravi Prakash on 6/26/18.
//  Copyright © 2018 xpd54. All rights reserved.
//

import UIKit

class AddPayeeViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Not checking if payee already exist or not
    @IBAction func add(_ sender: Any) {
        let name = self.name.text
        let email = self.email.text
        if name != nil && email != nil {
            DataController.addPayee(name: name!, email: email!, initialBalance: 0.0)
            let successViewController = PaySuccessViewController()
            successViewController.transactionMessage = "Successfully added \(name!)"
            self.navigationController?.pushViewController(successViewController, animated: true)
        } else {
            // Pop to root if error happen
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
