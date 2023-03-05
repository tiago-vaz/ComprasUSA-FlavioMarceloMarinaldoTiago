//
//  AppDelegate.swift
//  FlavioMarceloMarinaldoTiago
//
//  Created by Flavio Caruso, Marcelo Mussi, Marinaldo Ferreira and Tiago Vaz on 16/02/23.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let appDefaults: [String: Any] = ["dolar_preference": "5.17", "iof_preference": "5.38"]
        UserDefaults.standard.register(defaults: appDefaults)
        
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ComprasUSA")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}



