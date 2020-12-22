//
//  ViewController.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/19.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SideMenu
import FontAwesome_swift
import Cheetah
import ViewAnimator

class ViewController: UIViewController, GADBannerViewDelegate, SideMenuNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    let userDefault = UserDefaults.standard
    var classInfo = [[[""]]]
    var hourInfo = [[""]]
    var className = [""]
    var menuOpened = false
    var tableHeight: CGFloat = 0
    var semesterNum = 0
    let tate = UserDefaults.standard.integer(forKey: "tate")
    let yoko = UserDefaults.standard.integer(forKey: "yoko")
    
    
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var semesterTableView: UITableView!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var showMenuOutlet: UIButton!
    @IBOutlet weak var classTableView: UIView!
    
    
    @IBAction func resetButton(_ sender: Any) {
        userDefault.removeObject(forKey: "notFirstOpen")
        userDefault.removeObject(forKey: "classInfo")
    }
    
    @IBAction func showMenu(_ sender: Any) {
        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        menu.settings.presentationStyle = .viewSlideOutMenuPartialIn
        menu.statusBarEndAlpha = 0
        present(menu, animated: true, completion: nil)
    }
    
    
    @IBAction func showMenuButton(_ sender: Any) {
        if menuOpened{
            backView.cheetah.alpha(0).duration(0.1).run()
            semesterTableView.cheetah.move(0, -tableHeight).duration(0.1).run().completion({() -> Void in
                self.backView.isHidden = true
                self.semesterTableView.isHidden = true
            })
            
            menuOpened = false
        } else{
            semesterTableView.reloadData()
            backView.isHidden = false
            semesterTableView.isHidden = false
            semesterTableView.cheetah.move(0, tableHeight).duration(0.1).run()
            backView.cheetah.alpha(0.65).duration(0.1).run()
            menuOpened = true
        }
        showMenuOutlet.cheetah.rotate(M_PI).duration(0.1).run()
    }
    

    @IBOutlet weak var switchOutlet: UISwitch!
    @IBAction func nortySwitch(_ sender: UISwitch) {
        classInfo = userDefault.object(forKey: "classInfo") as! [[[String]]]
        hourInfo = userDefault.object(forKey: "hourInfo") as! [[String]]
        if sender.isOn{
            for i in 1...(tate * yoko) {
                if classInfo[semesterNum][i][0] != "" {
                    let content = UNMutableNotificationContent()
                    content.title = classInfo[semesterNum][i][0]
                    content.body = classInfo[semesterNum][i][1]
                    content.sound = UNNotificationSound.default
                    content.userInfo = ["url": classInfo[i][2]]
                    
                    var notificationTime = DateComponents()
                    let period: Int = Int(classInfo[semesterNum][i][4])!
                    let day:Int = Int(classInfo[semesterNum][i][3])!
                    if Int(hourInfo[period][2])! < 5 {
                        if Int(hourInfo[period][0])! == 0 {
                            notificationTime.hour = 23
                        } else{
                            notificationTime.hour = Int(hourInfo[period][0])! - 1
                        }
                        notificationTime.minute = Int(hourInfo[period][2])! + 55
                    } else {
                        notificationTime.hour = Int(hourInfo[period][0])!
                        notificationTime.minute = Int(hourInfo[period][2])! - 5
                    }
                    notificationTime.weekday = day + 2
                    let trigger = UNCalendarNotificationTrigger.init(dateMatching: notificationTime, repeats: true)
                    let request = UNNotificationRequest(identifier: i.description, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    
                }
            }
            userDefault.set(true, forKey: "isOn")
        } else{
            for i in 0...(tate * yoko) {
                if classInfo[semesterNum][i][0] != "" {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [i.description])
                }
            }
            userDefault.set(false, forKey: "isOn")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classInfo = userDefault.object(forKey: "classInfo") as! [[[String]]]
        hourInfo = userDefault.object(forKey: "hourInfo") as! [[String]]
        className[0] = classInfo[0][0][0]
        for i in 1..<classInfo.count {
            print(classInfo.count)
            className.append(classInfo[i][0][0])
        }
        semesterNum = userDefault.integer(forKey: "semesterNum")
        
        semesterLabel.text = className[semesterNum]
        
        tableHeight = CGFloat(50 * (classInfo.count + 1))
        semesterTableView.frame.size.height = tableHeight
        semesterTableView.frame.origin.y -= tableHeight
        
        
        settingButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 27, style: .solid)
        settingButton.setTitle(String.fontAwesomeIcon(name: .cog), for: .normal)
        showMenuOutlet.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        showMenuOutlet.setTitle(String.fontAwesomeIcon(name: .chevronDown), for: .normal)
        
        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        menu.settings.presentationStyle = .viewSlideOutMenuPartialIn
        menu.statusBarEndAlpha = 0
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view)
        
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        userDefault.set(true, forKey: "notFirstOpen")
        userDefault.synchronize()
        switchOutlet.isOn = userDefault.bool(forKey: "isOn")
        let a = userDefault.object(forKey: "hourInfo") as! [[String]]
        var str = ""
        for i in 0..<7 {
            str += a[0][i]
        }
        //        dayCollectionView.collectionViewLayout = layout
        //        timeCollectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(bannerView.bounds.width)
        bannerView.load(GADRequest())
    }
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        settingButton.cheetah.rotate(M_PI * 2.2).duration(0.35).run()
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        settingButton.cheetah.rotate(-M_PI * 2.2).duration(0.35).run().completion({() -> Void in
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! ViewController
            UIApplication.shared.keyWindow?.rootViewController = secondViewController
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classInfo.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if classInfo.count == indexPath.row {
            let cell = semesterTableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath as IndexPath)
            return cell
        } else{
            let cell = semesterTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            let label = cell.viewWithTag(1) as! UILabel
            label.text = className[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if classInfo.count == indexPath.row {
            classInfo.append([["新規時間割"]])
            for _ in 0..<(tate * yoko) {
                classInfo[classInfo.count - 1].append(["","","","",""])
            }
            var semesuterCount = userDefault.integer(forKey: "semesterCount")
            semesuterCount += 1
            userDefault.set(semesuterCount, forKey: "semesterCount")
            userDefault.set(classInfo, forKey: "classInfo")
        }
        semesterNum = indexPath.row
        userDefault.set(semesterNum, forKey: "semesterNum")
        userDefault.synchronize()
        backView.cheetah.alpha(0).duration(0.1).run()
        semesterTableView.cheetah.move(0, -tableHeight).duration(0.1).run().completion({() -> Void in
            self.backView.isHidden = true
            self.semesterTableView.isHidden = true
        })
        menuOpened = false
        showMenuOutlet.cheetah.rotate(M_PI).duration(0.1).run()
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! ViewController
        UIApplication.shared.keyWindow?.rootViewController = secondViewController
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension UIColor {
    /// 16進カラーコードでカラーを生成
    ///
    /// - Parameters:
    ///   - hex: 16進カラーコード
    ///   - alpha: アルファ値
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        let red: CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green: CGFloat = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue: CGFloat = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
