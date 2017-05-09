//
//  AppDelegate.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-10.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import GoogleMapsCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /**
         Google Maps API Key
        */
        GMSPlacesClient.provideAPIKey("AIzaSyCaaro8QMrdDg9oY3cjtuMOJZglUaDpUoU")
        GMSServices.provideAPIKey("AIzaSyCaaro8QMrdDg9oY3cjtuMOJZglUaDpUoU")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RCBB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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

