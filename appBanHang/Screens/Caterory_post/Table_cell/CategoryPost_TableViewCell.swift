//
//  CategoryPost_TableViewCell.swift
//  appBanHang
//
//  Created by DucPham on 05/06/2022.
//

import UIKit

class CategoryPost_TableViewCell: UITableViewCell {

    
    @IBOutlet weak var img_Category: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
