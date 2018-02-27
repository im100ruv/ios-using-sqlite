//
//  SViewController.swift
//  UsingSQLite
//
//  Created by Im100ruv on 23/02/18.
//  Copyright © 2018 Im100ruv. All rights reserved.
//

import UIKit
import SQLite

func db_Create(){
    var database_conect: Connection!

    do {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent("../users").appendingPathExtension("sqlite3")
        print(fileURL)
        let database = try Connection(fileURL.path)
        database_conect = database
    } catch {
        print(error)
    }
    
}
