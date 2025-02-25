//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //Reference of DB
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        //        Message(sender: "user0430@test.com", body: "Hey"),
        //        Message(sender: "user0430a@test.com", body: "Hi, how are you"),
        //        Message(sender: "user0430@test.com", body: "Great GreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreatGreat")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "⚡️FlashChat"
        navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //registry custom design file(xib file)
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages(){
        //        messages = []
        //        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, err) in
        //            if let e = err {
        //                print("There is problem to retrieve data form DB: \(e)")
        //            } else {
        //                if let snapshotDocuments = querySnapshot?.documents {
        //                    for doc in snapshotDocuments {
        //                        let data = doc.data()
        //                        if let messageSender = data[K.FStore.senderField] as? String,
        //                           let messageBoday = data[K.FStore.bodyField] as? String{
        //                            let newMsg = Message(sender: messageSender, body: messageBoday)
        //                            self.messages.append(newMsg)
        //
        //                            DispatchQueue.main.async {
        //                                self.tableView.reloadData()
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //        }
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, err) in
            if let e = err {
                print("There is problem to retrieve data form DB: \(e)")
            } else {
                self.messages = []
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String,
                           let messageBoday = data[K.FStore.bodyField] as? String{
                            let newMsg = Message(sender: messageSender, body: messageBoday)
                            self.messages.append(newMsg)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                //after (re-)load data scroll screen down to the newst message
                                let indexpath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexpath, at: UITableView.ScrollPosition.top, animated: true)
                            }
                        }
                    }
                }
            }
        } // end of closure
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            
            db.collection(K.FStore.collectionName).addDocument(
                data: [
                    K.FStore.senderField : messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                    ]) { err in
                    if let e = err {
                        print("Error saving to Firestore: \(e)")
                    } else {
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                        print("Message successfully saved!")
                    }
                }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try
            Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//MARK: - Extention Tableview
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
//        cell.label.text = self.messages[indexPath.row].body
        
        let message = self.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        // if message.sender is same as current logged in user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
            
        return cell
    }
}

//MARK: - Just test table view delegate
extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
