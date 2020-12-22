//
//  HourTableViewCell.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/23.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit
import GoogleMobileAds




class HourTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UIAdaptivePresentationControllerDelegate, UITextFieldDelegate, GADBannerViewDelegate {
    
    
    var pickerView = UIPickerView()
    var data: [[String]] = [["0"], [":"], ["00"], [" ~ "], ["0"], [":"], ["00"]]
    var strArr = UserDefaults.standard.object(forKey: "hourInfo") as! [[String]]
    var hour: [String] = []
    let tate = UserDefaults.standard.integer(forKey: "tate")
    let yoko = UserDefaults.standard.integer(forKey: "yoko")
    let userDefault = UserDefaults.standard
    static var hours =  HourEditViewController().hour as [[String]]

    @IBOutlet weak var houtTextField: UITextField!
    @IBOutlet weak var hourLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        houtTextField.delegate = self
        for i in 0..<(tate-1) {
            let str = makeTime(index: i)
            hour.append(str)
        }
        
        createPickerView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var str = ""
        strArr[houtTextField.tag][component] = data[component][row]
        for i in 0..<7 {
            str += strArr[houtTextField.tag][i]
        }
        HourTableViewCell.hours[houtTextField.tag][component] = data[component][row]
        houtTextField.text = str
        print(HourTableViewCell.hours[houtTextField.tag])
        print(HourEditViewController().hour)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 40
    }

    func createPickerView() {
        
        for i in 1..<24 {
            data[0].append(String(i))
            data[4].append(String(i))
        }
        for i in 1..<60 {
            var stri = ""
            if i < 10 {
                stri = "0\(i)"
            } else {
                stri = String(i)
            }
            data[2].append(stri)
            data[6].append(stri)
        }
        pickerView.delegate = self
        houtTextField.inputView = pickerView
        // toolbar
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 44)
        

        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(HourTableViewCell.donePicker))
        toolbar.setItems([doneButtonItem], animated: true)
        houtTextField.inputAccessoryView = toolbar
    }
    
    func setupCell(index: Int) {
        hourLabel.text = "\(index + 1)限"
        houtTextField.text = makeTime(index: index)
    }
    
    func makeTime(index: Int) -> String{
        let a = userDefault.object(forKey: "hourInfo") as! [[String]]
        var str = ""
        for i in 0..<7 {
            str += a[index][i]
        }
        return str
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print(1111)
    }

    @objc func donePicker() {
        houtTextField.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        houtTextField.endEditing(true)
    }
    

}
