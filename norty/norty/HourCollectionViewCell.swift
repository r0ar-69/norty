//
//  HourCollectionViewCell.swift
//  norty
//
//  Created by 清浦駿 on 2020/05/21.
//  Copyright © 2020 清浦駿. All rights reserved.
//

import UIKit

class HourCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func setupCell(index: Int) {
        let num = index + 1
        label.text = num.description
    }
}
