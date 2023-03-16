//
//  Yourlist_ViewController.swift
//  appBanHang
//
//  Created by DucPham on 28/05/2022.
//

import UIKit

class Yourlist_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arr_Post:[Post] = []
    var TenNhom:String="nhom"
    var idNhom:String="1"
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var YourTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        YourTable.dataSource = self
        YourTable.delegate = self
        // load list view post
        let url = URL(string: Config.ServerURL + "/post")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
               
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
            guard error == nil else { print("error"); return }
            guard let data = data else { return }
                       
            let jsonDecoder = JSONDecoder()
            let listPost = try? jsonDecoder.decode(PostRoute.self, from: data)
                
            self.arr_Post = listPost!.PostList
                
            DispatchQueue.main.async {
                    self.YourTable.reloadData()
            }
        })
        taskUserRegister.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let SpCell = YourTable.dequeueReusableCell(withIdentifier: "YOURCELL") as! YourList_TableViewCell
        SpCell.lblNameSP.text = arr_Post[indexPath.row].DienThoai
        SpCell.lblGia.text = arr_Post[indexPath.row].Gia
        SpCell.lblMoTa.text = arr_Post[indexPath.row].TieuDe
        SpCell.lblNhom.text = tenNhom(idNhom:arr_Post[indexPath.row].Nhom)
        
        let queueLoadCateImg = DispatchQueue(label: "queueLoadCateImg")
        queueLoadCateImg.async {
            //load hinh
            let urlSPImmg = URL(string: Config.ServerURL +  "/upload/" +  self.arr_Post[indexPath.row].Image)
            
            do{
                
                let dataSPImg = try Data(contentsOf: urlSPImmg!)
                DispatchQueue.main.async {
                    SpCell.imgHinhSP.image = UIImage(data: dataSPImg)
                }
            }catch{ print("Error")}
            
        }
        return SpCell
    }
    
    @IBAction func Goto_Post(_ sender: Any) {
        DispatchQueue.main.async {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let Post_VC = sb.instantiateViewController(identifier:"CREATEPOOST") as! CreatePoost_ViewController
        self.navigationController?.pushViewController(Post_VC, animated: true)}
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.self.height/4
    }
    func tenNhom(idNhom:String) -> String{
            let url = URL(string: "http://localhost:3000/category/findnhom")
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
               
            let sData = "idCate="+idNhom
               
            let postData = sData.data(using: .utf8)
            urlRequest.httpBody = postData
            
        
            let taskUserRegister = URLSession.shared.dataTask(with: urlRequest, completionHandler:{ data, response, error in
            guard let data = data,
                  error == nil else{return}
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
                           
                    if( json["kq"] as! Bool  == true ){
                        print("ok")
                        self.TenNhom =  json["Nhom"] as! String
                        
                    }else{
                        print("error")
                        }
                                                   
                    }catch let error { print(error.localizedDescription) }
            })
        taskUserRegister.resume()
        return TenNhom
    }
    
}
