//
//  ViewController.swift
//  Transference
//
//  Created by Ravi Prakash on 6/24/18.
//  Copyright © 2018 xpd54. All rights reserved.
//

import UIKit
import QuartzCore
import FirebaseUI
class ViewController: UIViewController {
    @IBOutlet var balance: UILabel!
    @IBOutlet var addPayee: UIButton!
    @IBOutlet var payButton: UIButton!

    let authUI = FUIAuth.defaultAuthUI()!
    var user = Auth.auth().currentUser
    override func viewDidLoad() {
        // Set Display name
        self.title = Label.Title

        // setup signup methods for firebase
        authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        self.authUI.providers = providers
        // check if current user is still login
        if user != nil {
            self.title = user!.displayName;
        } else {
            showSignInUI()
        }
        // update current balance

        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        // update current balance if user if loged in
        if Auth.auth().currentUser != nil {
            updateCurrentBalance()
        }
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func showSignInUI() {
        let authViewController = authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func updateCurrentBalance() {
        DataController.fetchCurrentBalance { (balance) in
            if let currentBalance = balance {
                self.balance.text = "\(currentBalance)$"
            }
        }
    }

    @IBAction func AddPayee(_ sender: UIButton) {
        let addPayeeViewController = AddPayeeViewController()
        self.navigationController?.pushViewController(addPayeeViewController, animated: true)
    }

    @IBAction func Pay(_ sender: Any) {
        let payeeViewController = PayeeTableViewController()
        self.navigationController?.pushViewController(payeeViewController, animated: true)
    }
}

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            // handle error
        } else {
            updateCurrentBalance()
            // set user name as title
            let currentUserName = authDataResult?.user.displayName
            self.title = currentUserName
            let currentUserEmail = authDataResult?.user.email
            DataController.fetchCurrentBalance { (balance) in
                // give them initial 100.0$ balance for signup 😛 to pay with it
                if balance != nil && (balance?.isEqual(to: 0.0))! {
                    DataController.addPayee(name: currentUserName!, email: currentUserEmail!, initialBalance: 100.0)
                } else {
                    // already a payee don't do anything
                }
            }
        }
        
    }
}
