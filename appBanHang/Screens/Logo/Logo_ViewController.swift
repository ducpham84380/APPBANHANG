//
//  Logo_ViewController.swift
//  appBanHang
//
//  Created by DucPham on 28/05/2022.
//

import UIKit

class Logo_ViewController: UIViewController {
    
    
    @IBOutlet weak var img_Logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_Logo.frame.origin.x = 0 - img_Logo.frame.size.width
        UIView.animate(withDuration: 3, animations: {
            self.img_Logo.frame.origin = CGPoint(x: self.view.frame.size.width/2 - self.img_Logo.frame.size.width/2,
                                                 y: self.view.frame.size.height/2 - self.img_Logo.frame.size.width/2)
        },completion: nil)
    }
    

   
}
