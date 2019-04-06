//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD
class RegisterViewController: UIViewController {

    
   

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject)
    {
        //TODO: Set up a new user on our Firbase database
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
        { (user, error) in
            
                if error != nil
                {
                    SVProgressHUD.dismiss()
                    let alert = AlertView.show(aTitle: "Wrong", aMessage: "Reenter email")
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    SVProgressHUD.dismiss()
                    print("Successful Register")
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                    
                }
                
            
            
        }
        
        
        
        

        
        
    } 
    
    
}
