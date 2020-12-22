//
//  DayViewController.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/19.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let yoko = UserDefaults.standard.integer(forKey: "yoko")
    
    @IBOutlet weak var dayCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DayCollectionViewCell", bundle: nil)
            dayCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let layout = UICollectionViewFlowLayout()
        let screenWidth = self.dayCollectionView.bounds.width
        let screenHeight = self.dayCollectionView.bounds.height
        
        let width: CGFloat = CGFloat(screenWidth) / CGFloat(yoko)
        let height: CGFloat = CGFloat(screenHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        dayCollectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        yoko
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cell as? DayCollectionViewCell {
            cell.setupCell(index: indexPath.row)
        }
        return cell
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
