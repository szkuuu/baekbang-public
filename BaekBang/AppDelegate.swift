//
//  AppDelegate.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/09.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }
        window.tintColor = .bbAccent
        let realm = try! Realm()
        let bbUserList = realm.objects(BBUser.self)
        if bbUserList.count > 0 {
            guard let savedUser = realm.objects(BBUser.self).first else { return false }
            BBNetworking.User.login(at: savedUser) { result in
                switch result {
                case .success(let json):
                    let retPck = json.arrayValue[0]
                    let newToken = retPck["login"]["token"].stringValue
                    if retPck["result"].boolValue {
                        NSLog("Token published: \(savedUser.token) -> \(newToken)")
                        try! realm.write {
                            savedUser.token = newToken
                        }
                        let rootViewController = BBHomeViewController()
                        rootViewController.bbUser = savedUser
                        let navigationController = UINavigationController(rootViewController: rootViewController)
                        window.rootViewController = navigationController
                        window.makeKeyAndVisible()
                    } else {
                        try! realm.write {
                            realm.delete(savedUser)
                        }
                        let rootViewController = BBSignUpViewController()
                        rootViewController.bbUser = BBUser()
                        let navigationController = UINavigationController(rootViewController: rootViewController)
                        window.rootViewController = navigationController
                        window.makeKeyAndVisible()
                    }
                case .failure(let err):
                    print(err)
                    let rootViewController = BBSignUpViewController()
                    rootViewController.bbUser = BBUser()
                    let navigationController = UINavigationController(rootViewController: rootViewController)
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            }
        } else {
            let rootViewController = BBSignUpViewController()
            rootViewController.bbUser = BBUser()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        return true
    }
}
