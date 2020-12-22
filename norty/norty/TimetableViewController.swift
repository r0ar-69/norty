//
//  TimetableViewController.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/19.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit

class TimetableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAdaptivePresentationControllerDelegate {

    
    var selectedClassNum = 0
    let yoko = UserDefaults.standard.integer(forKey: "yoko")
    let tate = UserDefaults.standard.integer(forKey: "tate")
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var timeTableView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let nib = UINib(nibName: "TimetableCollectionViewCell", bundle: nil)
        timeTableView.register(nib, forCellWithReuseIdentifier: "cell")
        
        let layout = UICollectionViewFlowLayout()
        let screenWidth = self.timeTableView.bounds.width
        let screenHeight = self.timeTableView.bounds.height
        let width: CGFloat = CGFloat(screenWidth) / CGFloat(yoko)
        let height: CGFloat = CGFloat(screenHeight) / CGFloat(tate)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        timeTableView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
        timeTableView.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yoko * tate
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBackground
        if let cell = cell as? TimetableCollectionViewCell {
            cell.setupCell(indexPath: indexPath.row + 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedClassNum = indexPath.row
        
        let classDetailViewController = storyboard?.instantiateViewController(identifier: "ClassDetailViewController") as! ClassDetailViewController
        classDetailViewController.presentationController?.delegate = self
        classDetailViewController.classNumber = indexPath.row + 1
        classDetailViewController.modalTransitionStyle = .crossDissolve
        present(classDetailViewController, animated: true, completion: nil)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        timeTableView.reloadData()
        print("reloaded!!!!!!!!1!")
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
