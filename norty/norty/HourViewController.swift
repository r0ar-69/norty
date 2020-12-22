//
//  HourViewController.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/19.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit
import ViewAnimator

class HourViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let userDefault = UserDefaults.standard
    let tate = UserDefaults.standard.integer(forKey: "tate")

    @IBOutlet weak var hourCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "HourCollectionViewCell", bundle: nil)
            hourCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        let layout = UICollectionViewFlowLayout()
        let screenWidth = self.hourCollectionView.bounds.width
        let screenHeight = self.hourCollectionView.bounds.height
        let width: CGFloat = CGFloat(screenWidth)
        let height: CGFloat = CGFloat(screenHeight) / CGFloat(tate)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        hourCollectionView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tate
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cell as? HourCollectionViewCell {
            cell.setupCell(index: indexPath.row)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toHourEdit", sender: nil)
        
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
