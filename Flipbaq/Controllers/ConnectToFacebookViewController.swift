//
//  ConnectToFacebookViewController.swift
//  Flipbaq
//
//  Created by Mary Marielle Miranda on 09/09/2017.
//  Copyright © 2017 Zed Philippines. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ConnectToFacebookViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //MARK: - Properties

    @IBOutlet weak var fbButton: FBSDKLoginButton!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fbButton.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    //MARK: - Custom
    func getFBUserData() {
        guard FBSDKAccessToken.current() != nil else {
            DispatchQueue.main.async {
                self.fbButton.isEnabled = true
            }
            
            return
        }
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            guard error != nil else {
                DispatchQueue.main.async {
                    self.fbButton.isEnabled = true
                }
                
                return
            }
            
            print(result)
            let parametersDictionary = ["fields": "id, name, first_name, last_name, picture.type(large), email"]
            
            let request = FBSDKGraphRequest(graphPath: "me", parameters: parametersDictionary as AnyObject as! [NSObject : AnyObject], httpMethod: "GET")
            request!.start(completionHandler: { (connection, result, error) -> Void in
                
                let dictionaryResult = result as! [String: Any]
                print(result)
                
                let dictionaryPicture = dictionaryResult["picture"] as! NSDictionary
                let dictionaryData = dictionaryPicture["data"] as! NSDictionary
                
//                self.user?.profileImage = dictionaryData["url"] as! String
//                self.user?.firstName = dictionaryResult["first_name"] as! String
//                self.user?.email = dictionaryResult["email"] as! String
//                self.user?.lastName = dictionaryResult["last_name"] as! String
//                self.user?.facebookID = dictionaryResult["id"] as! String
//                self.user?.gender = dictionaryResult["gender"] as! String
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToTutorial", sender: nil)
                }
                
                
            })
        })
    }
    
    //MARK: - IBAction Delegate
    @IBAction func didConnectToFacebook(_ sender: FBSDKLoginButton) {
        sender.isEnabled = false
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: nil) { (result, error) -> Void in
            guard error != nil else {
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
                
                return
            }
            
            self.getFBUserData()
        }
    }
    
    //MARK: - FBSDKLoginButton Delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard FBSDKAccessToken.current() != nil else {
            DispatchQueue.main.async {
                self.fbButton.isEnabled = true
            }
            
            return
        }
        
        let parametersDictionary = ["fields": "id, name, first_name, last_name, picture.type(large), email"]
        
        let request = FBSDKGraphRequest(graphPath: "me", parameters: parametersDictionary as AnyObject as! [NSObject : AnyObject], httpMethod: "GET")
        request!.start(completionHandler: { (connection, result, error) -> Void in
            
            let dictionaryResult = result as! [String: Any]
            print(result)
            
            let dictionaryPicture = dictionaryResult["picture"] as! NSDictionary
            let dictionaryData = dictionaryPicture["data"] as! NSDictionary
            
            //                self.user?.profileImage = dictionaryData["url"] as! String
            //                self.user?.firstName = dictionaryResult["first_name"] as! String
            //                self.user?.email = dictionaryResult["email"] as! String
            //                self.user?.lastName = dictionaryResult["last_name"] as! String
            //                self.user?.facebookID = dictionaryResult["id"] as! String
            //                self.user?.gender = dictionaryResult["gender"] as! String
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToTutorial", sender: nil)
            }
            
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}
