//
//  CreatePoost_ViewController.swift
//  appBanHang
//
//  Created by DucPham on 05/06/2022.
//

import UIKit


class CreatePoost_ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, Category_Delegate {
    func chonNhom(idNhom: String, tenNhom: String) {
        self.navigationController?.popViewController(animated: true)
        lblCategroy.text = tenNhom
        idNhom_Update = idNhom
    }
    
    
    

    

    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var lblCategroy: UILabel!
    @IBOutlet weak var txtNameProduct: UITextField!
    var fileimg:String = "sanpham.png"
    var idNhom_Update:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func Click_img(_ sender: Any) {
        // lam gi cung dc
    }
    
    
    @IBAction func btnUpload(_ sender: Any) {
        sendPostInto_server()
    }
    
    @IBAction func ChonHinh(_ sender: Any) {
        let image = UIImagePickerController();
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
    }
    
    @IBAction func Click_Category(_ sender: Any) {
        DispatchQueue.main.async {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let Category_VC = sb.instantiateViewController(identifier: "CATRTORY_POST") as! CateroryPost_ViewController
            Category_VC.delegate = self
        self.navigationController?.pushViewController(Category_VC, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage{
            imgPost.image = image
            uploadPhoto(paramName: "hinhdaidien", fileName: "SanPham.png", image: imgPost.image!)
        }else{print("loi")}
        self.dismiss(animated: true,completion: nil)
    }
    
    func uploadPhoto(paramName:String, fileName:String, image:UIImage){
        let url = URL(string: "http://localhost:3000/uploadFile")
        let boundary = UUID().uuidString
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\";filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: urlRequest, from: data) { data, urlReponse, error in
            if error == nil {
                do{
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: [])as?[String:String]{
                        print(json)
                        self.fileimg = json["file"]! as String
                    }else{print("error")}
                }catch{
                    print("fail load :\(error.localizedDescription)")}
            }
        }.resume()}
    
    func sendPostInto_server(){
        let url = URL(string: "http://localhost:3000/post/AddNew")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        var sData = "TieuDe="+self.txtTitle.text!
            sData += "&Gia="+self.txtPrice.text!
            sData += "&DienThoai="+self.txtNameProduct.text!
            sData += "&Image="+fileimg
            sData += "&Nhom=" + self.idNhom_Update
               
        let postData = sData.data(using: .utf8)
        urlRequest.httpBody = postData
    
        let taskCreatePost = URLSession.shared.dataTask(with: urlRequest, completionHandler:{ data, response, error in
        guard let data = data,
              error == nil else{return}
            do{
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
                       
                if( json["kq"] as! Bool  == true ){
                    DispatchQueue.main.async {
                            let alertView = UIAlertController(title: "Thong bao", message: "Post thanh cong", preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler:{(action:UIAlertAction!) in
                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                let yourlist_VC = sb.instantiateViewController(identifier: "YOURLIST") as! Yourlist_ViewController
                                self.navigationController?.pushViewController(yourlist_VC, animated: false)}))
                            self.present(alertView, animated: false, completion: nil)}
                    
                }else{
                    DispatchQueue.main.async {
                            let alertView = UIAlertController(title: "Thong bao", message: (json["errMsg"] as! String), preferredStyle: .alert)
                                alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alertView, animated: true, completion: nil)}
                    }
                                               
                }catch let error { print(error.localizedDescription) }
        
        })
        taskCreatePost.resume()
    }
           
}
    



