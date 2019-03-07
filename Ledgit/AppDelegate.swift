//
//  AppDelegate.swift
//  Ledgit
//
//  Created by Marcos Ortiz on 8/12/17.
//  Copyright © 2017 Camden Developers. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Set up Firebase
        FirebaseApp.configure()

        window = UIWindow(frame: UIScreen.main.bounds)

        // Determine which screen to go to depending on current user status
        // If there is no uid in user defaults, that can mean:
        //   1) First time launch of the app
        //   2) User deleted app, and all core data associated with it,
        //      which means they either had a free version, or they will have to login

        guard let uid = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.uid) as? String else {
            navigateToMain()
            return true
        }

        // If uid exist, search for a core data user
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.LedgitEntity.user)
        request.predicate = NSPredicate(format: "\(Constants.UserDefaultKeys.uid) == %@", uid)
        request.fetchLimit = 1

        do {
            let users = try persistentContainer.viewContext.fetch(request)

            guard let user = users.first as? NSManagedObject else {
                navigateToMain()
                return true
            }

            let data: NSDictionary = [
                LedgitUser.Keys.key: user.value(forKey: LedgitUser.Keys.key) as Any,
                LedgitUser.Keys.name: user.value(forKey: LedgitUser.Keys.name) as Any,
                LedgitUser.Keys.email: user.value(forKey: LedgitUser.Keys.email) as Any,
                LedgitUser.Keys.provider: user.value(forKey: LedgitUser.Keys.provider) as Any,
                LedgitUser.Keys.categories: user.value(forKey: LedgitUser.Keys.categories) as Any,
                LedgitUser.Keys.subscription: user.value(forKey: LedgitUser.Keys.subscription) as Any,
                LedgitUser.Keys.homeCurrency: user.value(forKey: LedgitUser.Keys.homeCurrency) as Any
            ]

            LedgitUser.current = LedgitUser(dict: data)
            navigateToTrips()
            return true

        } catch {

            LedgitLog.critical("Something is wrong. There is a user default uid value, but it didn't get the core data member")
            navigateToMain()
            return true
        }
    }

    func navigateToMain() {
        let navigationController = MainNavigationController.instantiate(from: .main)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func navigateToTrips() {
        let navigationController = TripsNavigationController.instantiate(from: .trips)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case "AddEntryShortcut":
            let navigationController = TripsNavigationController.instantiate(from: .trips)
            let entryActionViewController = EntryActionViewController.instantiate(from: .trips)
            navigationController.pushViewController(entryActionViewController, animated: true)

        default: break
        }

        completionHandler(true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack
    @available(iOS 10.0, *)

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Ledgit")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
