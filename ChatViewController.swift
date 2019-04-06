//
//  ViewController.swift
//  Flash Chat
//
//  
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray:[Message] = [Message]()
   
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        
         messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set yourself as the delegate of the text field here:
         messageTextfield.delegate = self
        
        //TODO: Set the tapGesture here:
        let mygestureTap = UITapGestureRecognizer(target: self, action: #selector(tableviewTapped))
        messageTableView.addGestureRecognizer(mygestureTap)
        

        //TODO: Register your MessageCell.xib file here:
       messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier:"customMessageCell")
        configuretableview()
        retrieveMessages()
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"customMessageCell") as! CustomMessageCell
    
        
        cell.messageBody.text =  messageArray[indexPath.row].messagebody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email as! String
        {
          cell.avatarImageView.backgroundColor = UIColor.flatGray()
            cell.messageBackground.backgroundColor = UIColor.flatWhite()
            
        }
        else
        {
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlue()
            
        }
        
        
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableviewTapped()
    {
       
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configuretableview()
    {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        UIView.animate(withDuration: 0.50)
        {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        UIView.animate(withDuration: 0.50)
        {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    @IBAction func sendPressed(_ sender: AnyObject)
    {
         messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
      let messageDB = Database.database().reference().child("Messages")
      let messageDICTIONARY = ["Sender":Auth.auth().currentUser?.email,"Message":messageTextfield.text!]
        messageDB.childByAutoId().setValue(messageDICTIONARY)
        {(error,refrence) in
            if error != nil
            {
                
            }
            else
            {
               self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
                
            }
        }
        
        //TODO: Send the message to Firebase and save it in our database
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages()
    {
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded)
        { (snapshot) in
            let messageDICT = snapshot.value as! Dictionary<String,String>
            
            let messageBODY = messageDICT["Message"]!
            let messageSENDER = messageDICT["Sender"]!
            
            let details:Message = Message()
            details.sender = messageSENDER
            details.messagebody = messageBODY
            self.messageArray.append(details)
            self.configuretableview()
            self.messageTableView.reloadData()
        }
        
        
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
      do
        {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
     catch
        {
           let alert = AlertView.show(aTitle: "Warning", aMessage: "Connection Faild")
          self.present(alert, animated: true, completion: nil)
        }
    }
    


}
