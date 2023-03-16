//
//  ViewController.swift
//  appBanHang
//
//  Created by DucPham on 28/05/2022.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var img_avatar: UIImageView!
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // check login
        
        if let UserToken = self.defaults.string(forKey: "UserToken") {
            //verifyToken
            let url = URL(string: "http://localhost:3000/verifyToken")
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
               
            let sData = "Token=" + UserToken
                       
            let postData = sData.data(using: .utf8)
            urlRequest.httpBody = postData
                       
            let taskUserRegister = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data , response, error in
                guard error == nil else { print("error"); return }
                guard let data = data else { return }
                           
                do{
                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
                            if( json["kq"] as! Int == 1 ){
                                   
                                print("Okay")
                                let user = json["User"] as?  [String:Any]
                                let imgString =  user!["Image"] as? String
                                let urlHinh = "http://localhost:3000/upload/"+imgString!
                                DispatchQueue.main.async { [self] in
                                do{
                                    self.img_avatar.image = UIImage(named: "avatar")
                                    img_avatar.layer.cornerRadius = img_avatar.frame.width/2
                                    let imgData = try! Data(contentsOf: URL(string: urlHinh)!)
                                    self.img_avatar.image = UIImage(data: imgData)
                                }catch{print("User creation failed error:")}
                                    let name:String = user!["Name"] as! String
                                    let username:String = user!["Username"] as! String
                                    let address:String = user!["Address"] as! String
                                    self.txtName.text =     "Name:         " + name
                                    self.txtAddress.text =  "Address:     "+address
                                    self.txtUserName.text = "Username:   " + username
                                   }
                               }else{
                                   DispatchQueue.main.async {
                                      let sb = UIStoryboard(name: "Main", bundle: nil)
                                      let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
                                      self.navigationController?.pushViewController(login_VC, animated: false)
                                   }
                               }
                               
                           }catch let error { print(error.localizedDescription) }
                       })
                       taskUserRegister.resume()
            
        }else{
            DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(login_VC, animated: false)}
        }
    }
    
    
    @IBAction func btn_Logout(_ sender: Any) {
        if let UserToken = defaults.string(forKey: "UserToken") {
                        
                        let url = URL(string: Config.ServerURL +  "/logout")
                        var request = URLRequest(url: url!)
                        request.httpMethod = "POST"
                    
                          let sData = "Token=" + UserToken
                           
                           let postData = sData.data(using: .utf8)
                           request.httpBody = postData
                           
                           let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data , response, error in
                               guard error == nil else { print("error"); return }
                               guard let data = data else { return }
                               
                               do{
                                   guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else { return }
                    
                                   if( json["kq"] as! Int == 1 ){
                                       // Thanh cong
                                    
                                    self.defaults.removeObject(forKey: "UserToken")
                                    
                                    DispatchQueue.main.async {
                                        let sb = UIStoryboard(name: "Main", bundle: nil)
                                        let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
                                        self.navigationController?.pushViewController(login_VC, animated: false)
                                    }
                                       
                                       
                                   }else{
                                       DispatchQueue.main.async {
                                           let alertView = UIAlertController(title: "Thong bao", message: (json["errMsg"] as! String), preferredStyle: .alert)
                                           alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                           self.present(alertView, animated: true, completion: nil)
                                       }
                                   }
                                   
                               }catch let error { print(error.localizedDescription) }
                           })
                           taskUserRegister.resume()
                    
                }else{
                    print("User creation failed with error: ")
                }
    }
}

