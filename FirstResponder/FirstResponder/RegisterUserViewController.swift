//
//  RegisterUserViewController.swift
//  FirstResponder
//
//  Created by Ronny Håland on 11/4/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

import UIKit
import Alamofire
import TB
import SwiftyPlistManager
import Toast_Swift

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var userField:UITextField!
    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func register(){
        if userField.text != nil && emailField.text != nil && passField.text != nil {
            let user = userField.text!
            if !user.isUserName {
                return
            }
            let email = emailField.text!
            if !email.isEmail {
                return
            }
            
            let pass = passField.text!
            if pass.characters.count < 8 {
                return
            }
            let token = Singelton.shared.TokenID
            let parameters: [String: Any] = [
                "key" : "",
                "userdata":[
                    "name" : user,
                    "password": pass,
                    "devicetoken": token
                ]
            ]
            self.view.makeToastActivity(.center)
            Alamofire.request("http://34.232.174.236/api/register/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
                print(response)
                print(response.result)
                
                //MARK: - IF USER REGISTERED
                if response.result.isSuccess {
                    
                    let requestURL = "http://34.232.174.236/api/login/"
                    let APIKey = ""
                    
                    let JSON:[String: Any] = [
                        "key": APIKey,
                        "username" : user,
                        "password" : pass
                        
                    ]
                    //MARK: - Try to log in
                    Alamofire.request(requestURL, method: HTTPMethod.post, parameters: JSON, encoding: JSONEncoding.default).responseString { response in
                        if response.result.isSuccess {
                            SwiftyPlistManager.shared.save(response.result.value!, forKey: "userID", toPlistWithName: "Data") { (err) in
                                if err == nil {
                                    print("Value successfully saved into plist.")
                                }
                            }
                            SwiftyPlistManager.shared.getValue(for: "userID", fromPlistWithName: "Data") { (result, err) in
                                if err == nil {
                                    print("The Value is: '\(result ?? "No Value Fetched")'")
                                }
                            }
                            DispatchQueue.main.async {
                                self.view.hideToastActivity()
                                self.performSegue(withIdentifier: "registerSuccess", sender: nil)
                            }
                        }else {
                            DispatchQueue.main.async {
                                self.view.hideToastActivity()
                                self.performSegue(withIdentifier: "toLogin", sender: nil)
                            }
                        }
                    }
                }
                
            }
            TB.info("Sent Request")
        }
    }
    @IBAction func cancel(){
        // TODO: Goto login viewcontroller
        TB.info("Cancel Button pressed")
    }
    
}
