//
//  PayViewController.swift
//  Transference
//
//  Created by Ravi Prakash on 6/25/18.
//  Copyright © 2018 xpd54. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
    @IBOutlet var currentBalance: UILabel!
    @IBOutlet var transferAmount: UITextField!
    var payeeName = String()
    var payeeEmail = String()
    var balance = Float()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sending to \(payeeName)"
    }

    @IBAction func Send(_ sender: UIButton) {
        let amount = (transferAmount.text! as NSString).floatValue
        if amount.isLess(than: Float(balance)) {
            // process
        } else {
            //error
        }
    }

}
