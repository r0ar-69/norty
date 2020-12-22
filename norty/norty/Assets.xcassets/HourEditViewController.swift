//
//  HourEditViewController.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/23.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HourEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate, GADBannerViewDelegate {
    
    var hour = UserDefaults.standard.object(forKey: "hourInfo") as! [[String]]
    let tate = UserDefaults.standard.integer(forKey: "tate")
    

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var hourTableView: UITableView!
    @IBOutlet weak var modalView: UIView!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 26, style: .regular)
        editButton.setTitle(String.fontAwesomeIcon(name: .edit), for: .normal)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        let nib = UINib(nibName: "HourTableViewCell", bundle: nil)
        hourTableView.register(nib, forCellReuseIdentifier: "cell")
        hourTableView.rowHeight = 80
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bannerView.adSize = kGADAdSizeMediumRectangle
        bannerView.load(GADRequest())
    }

    override func viewWillDisappear(_ animated: Bool) {
        print(HourTableViewCell.hours) //こいつをuserに入れる
        userDefaults.set(HourTableViewCell.hours, forKey: "hourInfo")
        userDefaults.synchronize()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hourTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        

        if let cell = cell as? HourTableViewCell {
            cell.setupCell(index: indexPath.row)
            cell.houtTextField.tag = indexPath.row
            cell.houtTextField.text = cell.makeTime(index: indexPath.row)
        }
        return cell
    }
    
    func upView(view: UIView) {
        view.cheetah.move(0, 350).delay(0.005).duration(0.245).run()
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
