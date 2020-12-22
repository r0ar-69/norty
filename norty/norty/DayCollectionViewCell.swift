//
//  DayCollectionViewCell.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/21.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    let day = ["月", "火", "水", "木", "金", "土", "日"]
    
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(index: Int) {
        label.text = day[index]
    }

}
