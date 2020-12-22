//
//  TimetableCollectionViewCell.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/20.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit

class TimetableCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classRoom: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(indexPath: Int) {
        let classInfo = UserDefaults.standard.object(forKey: "classInfo") as! [[[String]]]
        let semesterNum = UserDefaults.standard.integer(forKey: "semesterNum")
        className.text = classInfo[semesterNum][indexPath][0]
        classRoom.text = classInfo[semesterNum][indexPath][1]
    }

}
