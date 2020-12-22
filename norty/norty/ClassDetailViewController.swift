//
//  ClassDetailViewController.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/19.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Hero

class ClassDetailViewController: UIViewController, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate, GADBannerViewDelegate {
    var classNumber = 0
    let userDefaults = UserDefaults.standard
    let semesterNum = UserDefaults.standard.integer(forKey: "semesterNum")
    var classInfo = UserDefaults.standard.object(forKey: "classInfo") as! [[[String]]]
    var notEditing = true
    var opendKeyboard = false
    let tate = UserDefaults.standard.integer(forKey: "tate")
    let yoko = UserDefaults.standard.integer(forKey: "yoko")
    
    @IBOutlet weak var classNameField: UITextField!
    @IBOutlet weak var classRoomField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var openURLButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    @IBAction func registerButton(_ sender: Any) {
        if notEditing {
            classNameField.becomeFirstResponder()
            notEditing = false
        } else{
            notEditing = true
            classInfo[semesterNum][classNumber][0] = classNameField.text!
            classInfo[semesterNum][classNumber][1] = classRoomField.text!
            classInfo[semesterNum][classNumber][2] = urlField.text!
            classInfo[semesterNum][classNumber][3] = String(classNumber % 5)
            userDefaults.set(classInfo, forKey: "classInfo")
            userDefaults.synchronize()
            //self.dismiss(animated: true, completion: nil)
            classNameField.borderStyle = .none
            classRoomField.borderStyle = .none
            urlField.borderStyle = .none
            classNameField.resignFirstResponder()
            classRoomField.resignFirstResponder()
            urlField.resignFirstResponder()
        }
        
    }
    
    @IBAction func openURLButton(_ sender: Any) {
        let url = URL(string: urlField.text!)
        UIApplication.shared.open(url!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .regular)
        editButton.setTitle(String.fontAwesomeIcon(name: .edit), for: .normal)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        
        setUpLabel(index: classNumber)
        // Do any additional setup after loading the view.
        classNameField.text = classInfo[semesterNum][classNumber][0]
        classRoomField.text = classInfo[semesterNum][classNumber][1]
        urlField.text = classInfo[semesterNum][classNumber][2]
        if classInfo[semesterNum][classNumber][2] == ""{
            openURLButton.isEnabled = false
            openURLButton.setTitleColor(.systemGray3, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bannerView.adSize = kGADAdSizeMediumRectangle
        bannerView.load(GADRequest())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        classInfo[semesterNum][classNumber][0] = classNameField.text!
        classInfo[semesterNum][classNumber][1] = classRoomField.text!
        classInfo[semesterNum][classNumber][2] = urlField.text!
        classInfo[semesterNum][classNumber][3] = String((classNumber - 1) % yoko)
        userDefaults.set(classInfo, forKey: "classInfo")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 27, style: .regular)
        editButton.setTitle(String.fontAwesomeIcon(name: .save), for: .normal)
        classNameField.borderStyle = .roundedRect
        classRoomField.borderStyle = .roundedRect
        urlField.borderStyle = .roundedRect
        modalView.center = self.view.center
        UIView.animate(withDuration: 0.245, delay: 0.005, animations: {
            self.modalView.center.y -= 350.0
            self.bannerView.alpha = 0
        }, completion: nil)
        notEditing = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .regular)
        editButton.setTitle(String.fontAwesomeIcon(name: .edit), for: .normal)
        modalView.center = self.view.center
        classNameField.borderStyle = .none
        classRoomField.borderStyle = .none
        urlField.borderStyle = .none
        UIView.animate(withDuration: 0.24, delay: 0.0, animations: {
            self.modalView.center.y += 350.0
            self.bannerView.alpha = 1
        }, completion: nil)
        notEditing = true
        if classInfo[semesterNum][classNumber][2] != ""{
            openURLButton.isEnabled = true
            openURLButton.setTitleColor(UIColor(named: "textColor"), for: .normal)
        } else {
            openURLButton.isEnabled = false
            openURLButton.setTitleColor(.systemGray3, for: .normal)
        }
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
    
    func setUpLabel(index: Int) {
        
        var str = ""
        switch (index - 1) % yoko {
        case 0:
            str = "月曜"
            break
        case 1:
            str = "火曜"
            break
        case 2:
            str = "水曜"
            break
        case 3:
            str = "木曜"
            break
        case 4:
            str = "金曜"
            break
        case 5:
            str = "土曜"
            break
        case 6:
            str = "日曜"
            break
        default:
            break
        }
        
        var num = index - 1
        var i = 0
        while num >= yoko {
            num -= yoko
            i += 1
        }
        str += " \(i+1)限"

        classInfo[semesterNum][classNumber][4] = String(i)
        timeLabel.text = str
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
