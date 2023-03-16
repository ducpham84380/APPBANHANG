//
//  Register_ViewController.swift
//  appBanHang
//
//  Created by DucPham on 28/05/2022.
//

import UIKit

class Register_ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtNumberPhone: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var fileimg:String = "avatar.png"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func img_avatar(_ sender: Any) {
        let image = UIImagePickerController();
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
    }

    @IBAction func RegisterNewUser(_ sender: Any) {
        sendUserInto_server()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage{
            imgAvatar.image = image
            uploadPhoto(paramName: "hinhdaidien", fileName: fileimg, image: imgAvatar.image!)
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
                            print(json["file"] as Any )
                            self.fileimg = json["file"]!
                        }else{print("error")}
                    }catch{
                        print("fail load :\(error.localizedDescription)")}
                }
            }.resume()}
    
    func sendUserInto_server(){

        let url = URL(string: "http://localhost:3000/register")
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
               
            var sData = "Username="+self.txtUserName.text!
                sData += "&Password="+self.txtPassword.text!
                sData += "&Name="+self.txtName.text!
                sData += "&Image="+fileimg
                sData += "&Email="+self.txtEmail.text!
                sData += "&Address="+self.txtAddress.text!
                sData += "&PhoneNumber=" + self.txtNumberPhone.text!
                   
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
                                        let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
                                        self.navigationController?.pushViewController(login_VC, animated: false)}))
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
