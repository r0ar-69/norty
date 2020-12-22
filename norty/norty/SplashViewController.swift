//
//  SplashViewController.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/19.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit
import Cheetah
class SplashViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var animeView: UIView!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var allView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        anime()
    }
    
    func anime(){
        self.animeView.cheetah.wait(0.43).alpha(1).duration(0.01).wait(0.05).alpha(0).duration(0.01).wait(0.08).alpha(1).duration(0.01).wait(0.05).alpha(0).duration(0.01).run()
        self.allView.cheetah.wait(1.06).alpha(0).duration(0.3).run()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.26){
            self.performSegue(withIdentifier: "toMain", sender: nil)
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
