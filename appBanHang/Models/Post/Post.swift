//
//  Post.swift
//  appBanHang
//
//  Created by DucPham on 06/06/2022.
//

import Foundation

struct PostRoute:Decodable{
    var kq:Int
    var PostList:[Post]
}

struct Post:Decodable{
    var _id: String
    var TieuDe:String
    var Gia:String
    var DienThoai:String
    var Image:String
    var Nhom:String
    var NgayDang: String
   
    
    init(id:String, name:String, image:String, dienthoai:String, gia: String, nhom: String, title:String, ngaydang:String) {
        self._id = id
        self.DienThoai = name
        self.Image = image
        self.Gia = gia
        self.Nhom = nhom
        self.TieuDe = title
        self.NgayDang = ngaydang
    }
}
