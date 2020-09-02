//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var  baseClass = BaseClass()
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = Constances.appName
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constances.cellNibName, bundle: nil), forCellReuseIdentifier: Constances.cellIdentifier)
        readDataFromDtabase()
    }
    
    func readDataFromDtabase() {
        
        db.collection(Constances.FStore.collectionName)
            .order(by: Constances.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let error = error{
                self.baseClass.alertController(with: error.localizedDescription)
            }
            else{
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents{
                    let data = document.data()
                    if let sender = data[Constances.FStore.senderField] as? String, let messageBody = data[Constances.FStore.bodyField] as? String{
                        let newMessage = Message(sender: sender, body: messageBody)
                        self.messages.append(newMessage)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: (self.messages.count - 1), section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email else{return}
        db.collection(Constances.FStore.collectionName).addDocument(data: [
            Constances.FStore.senderField: messageSender,
            Constances.FStore.bodyField : messageBody,
            Constances.FStore.dateField : Date().timeIntervalSince1970
        ]) { (error) in
            if let error = error{
                self.baseClass.alertController(with: error.localizedDescription)
            }
            else{
                self.messageTextfield.text = ""
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            baseClass.alertController(with: signOutError.domain)
        }
    }
    
}

//MARK: - Tableview DataSource Methods
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constances.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        if message.sender == Auth.auth().currentUser?.email {
            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constances.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: Constances.BrandColors.purple)
        }
        else{
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constances.BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: Constances.BrandColors.lightPurple)
        }
        return cell
    }
}

//MARK: - Tableview Delegate Methods
extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
