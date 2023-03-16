//
//  CateroryPost_ViewController.swift
//  appBanHang
//
//  Created by DucPham on 05/06/2022.
//

import UIKit

protocol Category_Delegate{
    func chonNhom(idNhom:String, tenNhom:String)
}

class CateroryPost_ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    var delegate:Category_Delegate?
        
    var arr_Cate:[Category] = []
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        delegate?.chonNhom(idNhom: arr_Cate[indexPath.row]._id, tenNhom: arr_Cate[indexPath.row].Name)
            
        
        }
   
    @IBOutlet weak var MyTable_CategoryPost: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MyTable_CategoryPost.dataSource = self
        MyTable_CategoryPost.delegate = self
        //load Category
        let url = URL(string: Config.ServerURL + "/category")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
               
        let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
        guard error == nil else { print("error"); return }
        guard let data = data else { return }
                   
        let jsonDecoder = JSONDecoder()
        let listCate = try? jsonDecoder.decode(CategoryPostRoute.self, from: data)
            
        self.arr_Cate = listCate!.CateList
            
        DispatchQueue.main.async {
            self.MyTable_CategoryPost.reloadData()
        }
                   
        })
            taskUserRegister.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Cate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cateCell = MyTable_CategoryPost.dequeueReusableCell(withIdentifier: "CATECELL") as! CategoryPost_TableViewCell
                
                cateCell.lbl_name.text = arr_Cate[indexPath.row].Name
                
                let queueLoadCateImg = DispatchQueue(label: "queueLoadCateImg")
                queueLoadCateImg.async {
                    
                    let urlCateImmg = URL(string: Config.ServerURL +  "/upload/" +  self.arr_Cate[indexPath.row].Image)
                    print(Config.ServerURL +  "/upload/" +  self.arr_Cate[indexPath.row].Image)
                    do{
                        let dataCateImg = try Data(contentsOf: urlCateImmg!)
                        DispatchQueue.main.async {
                            cateCell.img_Category.image = UIImage(data: dataCateImg)
                        }
                    }catch{ print("Error")}
                }
                
       return cateCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height/4
    }
}
