//
//  ViewController.swift
//  MyCoreData
//
//  Created by Ramazan Abdullayev on 12.10.21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        
        getCoreDataDBPath()
        saveUserData()
        
        CoreDataController.sharedInstance.fetch(entity: User.self) { res in
            switch res {
            case .success(let result):
                print("Username: \(result.first?.username ?? "No name")")
                print("Passcode: \(result.first?.passcode ?? "No passcode added")")
                print("App language: \(result.first?.language ?? "No language selected")")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print("Core Data DB Path: \(path ?? "Not found")")
    }
    
    func saveUserData() {
        let context = CoreDataController.sharedInstance.context
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        let newUser = NSManagedObject(entity: userEntity!, insertInto: context)
        newUser.setValue("Ramazan", forKey: "username")
        newUser.setValue("az", forKey: "language")
        newUser.setValue("12345", forKey: "passcode")
        
        CoreDataController.sharedInstance.saveContext()
    }
        
}

