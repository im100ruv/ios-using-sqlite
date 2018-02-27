//
//  ViewController.swift
//  UsingSQLite
//
//  Created by Im100ruv on 22/02/18.
//  Copyright © 2018 Im100ruv. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var database: Connection!
    
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("../users").appendingPathExtension("sqlite3")
            print(fileURL)
            let database = try Connection(fileURL.path)
            self.database = database
        } catch {
            print(error)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTablePressed(_ sender: Any) {
        print("create pressed")
        
        let createTable = usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
        }
        do {
            try self.database.run(createTable)
            print("table created!")
        } catch {
            print(error)
        }
    }
    
    @IBAction func insertUserPressed(_ sender: Any) {
        print("insert pressed")
        let alert = UIAlertController(title: "insert user", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Name"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Email"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text, let email = alert.textFields?.last?.text else { return }
            print(name)
            print(email)
            
            let insertUser = self.usersTable.insert(self.name <- name, self.email <- email)
            do {
                try self.database.run(insertUser)
                print("user inserted!")
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteUserPressed(_ sender: Any) {
        print("delete pressed")
        let alert = UIAlertController(title: "delete user", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "UserName"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString)
                else { return }
            print(userIdString)
            
            let user = self.usersTable.filter(self.id == userId)
            let deleteUser = user.delete()
            do {
                try self.database.run(deleteUser)
                print("user deleted!")
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func updateUserPressed(_ sender: Any) {
        print("update pressed")
        let alert = UIAlertController(title: "update user", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "User Id"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Email"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString),
                let email = alert.textFields?.last?.text
                else { return }
            print(userIdString)
            print(email)
            
            let user = self.usersTable.filter(self.id == userId)
            let updateUser = user.update(self.email <- email)
            do {
                try self.database.run(updateUser)
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func listUserPressed(_ sender: Any) {
        print("list pressed")
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userId: \(user[self.id]), name: \(user[self.name]), email: \(user[self.email])")
            }
        } catch {
            print(error)
        }
    }
    


}

