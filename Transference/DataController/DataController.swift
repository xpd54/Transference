//
//  DataController.swift
//  KavyaSangrah
//
//  Created by Ravi Prakash on 6/24/18.
//  Copyright © 2018 Ravi Prakash. All rights reserved.
//

import UIKit
import Firebase
private var ref: DatabaseReference!

class DataController: NSObject {

    static func addPayee(name: String, email: String) -> Void {
        let userIndexKey = generateUserKey(email: email)
        ref = Database.database().reference().child(Label.DataBaseRoot).child(userIndexKey)
        let user = NSDictionary()
        user.setValue(name, forKey: Label.NameKey)
        user.setValue(email, forKey: Label.EmailKey)
        // Default balance of payee will be 0.0
        user.setValue(0.0, forKey: Label.BalanceKey)
        ref.updateChildValues(user as! [AnyHashable: Any])
    }

    static func transfer(amount:Float, payeeEmail:String, completion: @escaping (Bool) -> Void) {
        let currentUser = Auth.auth().currentUser
        let currentEmail = currentUser?.email
        let currentUserIndeKey = generateUserKey(email: currentEmail!)
        fetchCurrentBalance { (balance) in
            if balance != nil {
                let payeeIndex = generateUserKey(email: payeeEmail)
                fetchBalance(userEmail: payeeEmail, completion: { (payeeBalance) in
                    if payeeBalance != nil {
                        ref = Database.database().reference()
                        let currentChildref = ref.child(Label.DataBaseRoot).child(currentUserIndeKey)
                        currentChildref.updateChildValues([Label.BalanceKey: balance! - amount])

                        let payeeChildRef = ref.child(Label.DataBaseRoot).child(payeeIndex)
                        payeeChildRef.updateChildValues([Label.BalanceKey : payeeBalance! + amount])
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }

    static func fetchBalance(userEmail: String, completion: @escaping (Float?) -> Void) {
        var balance = NSNumber()
        fetchPayee { (listOfPayee) in
            if listOfPayee == nil {
                completion(nil)
            }
            for payee in listOfPayee! {
                let email = payee.object(forKey: Label.EmailKey) as! String
                if userEmail == email {
                    balance = payee.object(forKey: Label.BalanceKey) as! NSNumber
                    break;
                }
            }
            let balanceValue = Float(truncating: balance)
            completion(balanceValue)
        }
    }

    static func fetchCurrentBalance(completion: @escaping (Float?) -> Void) {
        let currentUserEmail = Auth.auth().currentUser?.email
        let currentUserIndex = generateUserKey(email: currentUserEmail!)
        ref = Database.database().reference().child(Label.DataBaseRoot).child(currentUserIndex).child(Label.BalanceKey)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let balance = snapshot.value as? Float
            if balance != nil {
                completion(balance!)
            } else {
                completion(0.0)
            }
        }
    }

    static func fetchPayee(completion:@escaping ([NSDictionary]?) -> Void) {
        ref = Database.database().reference()
        let currentUserEmail = Auth.auth().currentUser?.email!
        ref.child(Label.DataBaseRoot).observeSingleEvent(of: .value, with: { (snapshot) in
            // convert snapshot into array
            var listOfPayee = [NSDictionary]()
            let value = snapshot.value as? NSDictionary
            let allkeys = value?.allKeys as! [String]
            for key in allkeys {
                let user = value?.object(forKey: key) as! NSDictionary
                let userEmail = user.object(forKey: Label.EmailKey) as! String
                if userEmail == currentUserEmail {
                    continue
                }
                // keep the index key into dictionary for update use
                user.setValue(key, forKey: Label.IndexKey)
                listOfPayee.append(user)
            }
            completion(listOfPayee)
        }) { (error) in
            print(error.localizedDescription)
            completion(nil)
        }
    }

    static func generateUserKey(email: String) -> String {
        return email.components(separatedBy: CharacterSet.alphanumerics.inverted).joined(separator: "_")
    }
}
