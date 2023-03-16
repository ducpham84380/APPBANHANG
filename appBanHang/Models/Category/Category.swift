//
//  Category.swift
//  appBanHang
//
//  Created by DucPham on 05/06/2022.
//

import Foundation
struct CategoryPostRoute:Decodable{
    var kq:Int
    var CateList:[Category]
}

struct Category:Decodable{
    var _id: String
    var Name:String
    var Image:String
    
    init(id:String, name:String, image:String) {
        self._id = id
        self.Name = name
        self.Image = image
    }
}
