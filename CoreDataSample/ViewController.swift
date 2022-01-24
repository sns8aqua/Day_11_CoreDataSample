//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Santhosh on 23/01/22.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var displayTable: UITableView!
    
    var usersArray: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usersArray = [User]()
        
        self.displayTable.delegate = self
        self.displayTable.dataSource = self
        
        print(self.getDocumentDirectoryPath())
    }
    
    @IBAction func getDataClicked(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        ///fetchRequest.predicate = NSPredicate(format: "name == %@", "prakash")
        do {
            let result =   try manageContext.fetch(fetchRequest)
            usersArray = result
            self.displayTable.reloadData()
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    

    @IBAction func saveClicked(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: manageContext) else {return}
        if let name = nameText.text, let email = emailText.text, let password = passwordText.text {
            if !email.isValidEmail() {
                self.showAlert(message: "Please enter a valid email.")
                return
            }
            let user = NSManagedObject(entity: entity, insertInto: manageContext)
            user.setValue(name, forKeyPath: "name")
            user.setValue(email, forKeyPath: "email")
            user.setValue(password, forKeyPath: "password")
         
            do {
                try manageContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    
    
    
    func getDocumentDirectoryPath() -> URL? {
        guard let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return document
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTableViewCellIdentifier", for: indexPath)
        if let cellIs = cell as? DisplayTableViewCell {
            cellIs.setData(data: self.usersArray?[indexPath.row])
        }
        return cell
 
    }
    func showAlert(title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            print("Ok Clicked")
        })
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
}



extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
