//
//  PaySuccessViewController.swift
//  Transference
//
//  Created by Ravi Prakash on 26/6/2018.
//  Copyright © 2018 xpd54. All rights reserved.
//

import UIKit

class PaySuccessViewController: UIViewController {
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var sucessMessage: UILabel!
    var transactionMessage = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sucessMessage.text = transactionMessage
        DataController.fetchCurrentBalance { (balance) in
            self.currentBalance.text = "\(balance!)$"
        }
    }
}