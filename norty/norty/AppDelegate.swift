//
//  AppDelegate.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/19.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let userDefault = UserDefaults.standard
        let notFirstOpen = UserDefaults.standard.bool(forKey: "notFirstOpen")
        
        //userDefault.removeObject(forKey: "classInfo")

        userDefault.synchronize()
       
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
        //if notFirstOpen == false {
            //チュートリアル表示用
            
            setUp(userDefaults: userDefault)
      //  }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func setUp(userDefaults: UserDefaults) {
        var classInfo: [[[String]]] = [[["新規時間割"]]]
        var hourInfo: [[String]] = [["0", ":", "00", " ~ ", "0", ":", "00"]]
        for _ in 0..<25 {
            classInfo[0].append(["","","","",""])
        }
        for _ in 0..<5 {
            hourInfo.append(["0", ":", "00", " ~ ", "0", ":", "00"])
        }
        userDefaults.set(0, forKey: "norty")
        userDefaults.set(1, forKey: "semesterCount")
        userDefaults.set(0, forKey: "semesterNum")
        userDefaults.set(classInfo, forKey: "classInfo")
        userDefaults.set(hourInfo, forKey: "hourInfo")
        userDefaults.set(5, forKey: "tate")
        userDefaults.set(5, forKey: "yoko")
        userDefaults.synchronize()
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // アプリ起動時も通知を行う
        completionHandler([ .badge, .sound, .alert])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userinfo = response.notification.request.content.userInfo as [AnyHashable: Any]
        let url = URL(string: userinfo["url"] as! String)
        UIApplication.shared.open(url!)

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if userInfo["url"] as! String != ""{

        let url = URL(string: userInfo["url"] as! String)
        UIApplication.shared.open(url!)
        }
    }
}

