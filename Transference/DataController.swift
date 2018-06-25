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
    static func fetchCurrentBalance(comppletion: @escaping (Float64?) -> Void) {
        let currentUserEmail = Auth.auth().currentUser?.email
        var balance = NSNumber()
        
        fetchAllPayee { (listOfPayee) in
            for payee in listOfPayee! {
                let email = payee.object(forKey: Label.EmailKey) as! String
                if currentUserEmail == email {
                    balance = payee.object(forKey: Label.BalanceKey) as! NSNumber
                    break;
                }
            }
            let balanceValue = Float64(truncating: balance)
            comppletion(balanceValue)
        }
    }

    static func fetchAllPayee(completion:@escaping ([NSDictionary]?) -> Void) {
        ref = Database.database().reference()
        ref.child(Label.DataBaseRoot).observeSingleEvent(of: .value, with: { (snapshot) in
            // convert snapshot into array
            var listOfPayee = [NSDictionary]()
            let value = snapshot.value as? NSDictionary
            let allkeys = value?.allKeys as! [String]
            for key in allkeys {
                let user = value?.object(forKey: key) as! NSDictionary
                // keep the index key into dictionary for update use
                user.setValue(key, forKey: Label.IndexKey)
                listOfPayee.append(user)
            }
            completion(listOfPayee)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
