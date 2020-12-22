//
//  SideMenuViewController.swift
//  
//
//  Created by 清浦駿 on 2020/05/27.
//

import UIKit

class SideMenuViewController: UIViewController,UITextFieldDelegate {
    
    let userDefault = UserDefaults.standard
    let dayArr = ["月", "火", "水", "木", "金", "土" ,"日"]
    var semesterCount = UserDefaults.standard.integer(forKey: "semesterCount")
    var hourInfo = [[""]]
    var classInfo = [[[""]]]
    var semesterNum = 0
    var yoko = 0
    var tate = 0
    
    
    @IBOutlet weak var deleteOutlet: UIButton!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBAction func nortySwitch(_ sender: UISwitch) {
        classInfo = userDefault.object(forKey: "classInfo") as! [[[String]]]
        hourInfo = userDefault.object(forKey: "hourInfo") as! [[String]]
        if sender.isOn{
            for i in 1...(yoko*tate) {
                sendNorty(i: i)
            }
            userDefault.set(true, forKey: "isOn")
        } else{
            for i in 1..<(tate * yoko) {
                removeNorty(i: i)
            }
            userDefault.set(false, forKey: "isOn")
        }
    }
    
    @IBAction func dayPlusButton(_ sender: Any) {
        if yoko <= 6 {
            yoko += 1
            for i in 1...tate {
                for g in 0..<userDefault.integer(forKey: "semesterCount"){
                    classInfo[g].insert(["", "", "", "", ""], at: i * yoko)
                }
            }
            userDefault.set(yoko, forKey: "yoko")
            userDefault.set(classInfo, forKey: "classInfo")
            userDefault.synchronize()
            dayLabel.text = "月~\(dayArr[yoko - 1])"
        }
    }
    @IBAction func dayMinusButton(_ sender: Any) {
        if yoko >= 1 {
            for i in (1...tate).reversed() {
                for g in 0..<userDefault.integer(forKey: "semesterCount"){
                    classInfo[g].remove(at: i * yoko)
                }
            }
            yoko -= 1
            userDefault.set(yoko, forKey: "yoko")
            userDefault.set(classInfo, forKey: "classInfo")
            userDefault.synchronize()
            dayLabel.text = "月~\(dayArr[yoko - 1])"
        }
    }
    @IBAction func classPlusButton(_ sender: Any) {
        tate += 1
        for _ in 0..<yoko {
            for g in 0..<userDefault.integer(forKey: "semesterCount"){
                classInfo[g].append(["", "", "", "", ""])
            }
        }
        hourInfo.append(["0", ":", "00", " ~ ", "0", ":", "00"])
        userDefault.set(hourInfo, forKey: "hourInfo")
        classLabel.text = "\(tate)限まで"
        userDefault.set(classInfo, forKey: "classInfo")
        userDefault.set(tate, forKey: "tate")
        userDefault.synchronize()
    }
    @IBAction func classMinusButton(_ sender: Any) {
        if tate >= 2 {
            for _ in 0..<yoko {
                for g in 0..<userDefault.integer(forKey: "semesterCount"){
                    classInfo[g].removeLast()
                }
            }
            tate -= 1
            hourInfo.removeLast()
            userDefault.set(hourInfo, forKey: "hourInfo")
            print(hourInfo)
            userDefault.set(tate, forKey: "tate")
            userDefault.set(classInfo, forKey: "classInfo")
            userDefault.synchronize()
            classLabel.text = "\(tate)限まで"
        }
    }
    
    @IBAction func deleteClass(_ sender: Any) {
        classInfo.remove(at: semesterNum)
        semesterCount -= 1
        userDefault.set(semesterCount, forKey: "semesterCount")
        userDefault.set(classInfo, forKey: "classInfo")
        userDefault.set(0, forKey: "semesterNum")
        userDefault.synchronize()
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! ViewController
        UIApplication.shared.keyWindow?.rootViewController = secondViewController
        
    }
    
    
    
    override func viewDidLoad() {
        yoko = userDefault.object(forKey: "yoko") as! Int
        tate = userDefault.object(forKey: "tate") as! Int
        print(semesterCount)
        if semesterCount == 1 {
            deleteOutlet.isEnabled = false
            deleteOutlet.setTitleColor(UIColor(named: "textColor"), for: .normal)
        }
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        classInfo = userDefault.object(forKey: "classInfo") as! [[[String]]]
        hourInfo = userDefault.object(forKey: "hourInfo") as! [[String]]
        semesterNum = userDefault.object(forKey: "semesterNum") as! Int
        textField.text = classInfo[semesterNum][0][0]
        classLabel.text = "\(tate)限まで"
        dayLabel.text = "月~\(dayArr[yoko - 1])"
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        classInfo[semesterNum][0][0] = textField.text!
        userDefault.set(classInfo, forKey: "classInfo")
        userDefault.synchronize()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    public func sendNorty(i: Int) {
        if classInfo[semesterNum][i][0] != "" {
            let content = UNMutableNotificationContent()
            content.title = classInfo[semesterNum][i][0]
            content.body = classInfo[semesterNum][i][1]
            content.sound = UNNotificationSound.default
            if classInfo[semesterNum][i][2] != ""{
                
                content.userInfo = ["url": classInfo[semesterNum][i][2]]
            }
            
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
    
    public func removeNorty(i: Int) {
        if classInfo[semesterNum][i][0] != "" {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [i.description])
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
