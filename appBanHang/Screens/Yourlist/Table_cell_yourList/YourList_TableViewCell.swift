//
//  YourList_TableViewCell.swift
//  appBanHang
//
//  Created by DucPham on 06/06/2022.
//

import UIKit

class YourList_TableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblGia: UILabel!
    @IBOutlet weak var lblNhom: UILabel!
    @IBOutlet weak var imgHinhSP: UIImageView!
    @IBOutlet weak var lblMoTa: UILabel!
    @IBOutlet weak var lblNameSP: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
