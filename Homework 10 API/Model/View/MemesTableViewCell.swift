//
//  MemesTableViewCell.swift
//  Homework 10 API
//
//  Created by Ravil Gubaidulin on 02.01.2023.
//

import UIKit

class MemesTableViewCell: UITableViewCell {

    @IBOutlet weak var textLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setup(text: String) {
        self.textLable.text = text
    }

}
