//
//  Login_ViewController.swift
//  appBanHang
//
//  Created by DucPham on 28/05/2022.
//

import UIKit

class Login_ViewController: UIViewController {
    
    
    @IBOutlet weak var imglogo_dangnhap: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtEmail.backgroundColor = .clear
        txtEmail.layer.cornerRadius = 5
        txtEmail.layer.borderWidth = 1
        txtEmail.layer.borderColor = UIColor.black.cgColor
        
        txtPassword.backgroundColor = .clear
        txtPassword.layer.cornerRadius = 5
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.borderColor = UIColor.black.cgColor
    }
    

    @IBAction func btn_Login(_ sender: Any) {
        sendUserInto_login_server()
    }
    
    @IBAction func btn_RegisterView(_ sender: Any) {
        DispatchQueue.main.async {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let RegisterView_VC = sb.instantiateViewController(identifier: "REGISTER") as! Register_ViewController
        self.navigationController?.pushViewController(RegisterView_VC, animated: true)}
    }
    func sendUserInto_login_server(){

            var url = URL(string: "http://localhost:3000/login")
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
               
            var sData = "Password="+self.txtPassword.text!
                sData += "&Email="+self.txtEmail.text!
                
                   
            let postData = sData.data(using: .utf8)
            urlRequest.httpBody = postData
        
            let taskUserRegister = URLSession.shared.dataTask(with: urlRequest, completionHandler:{ data, response, error in
            guard let data = data,
                  error == nil else{return}
            let jsonDecoder = JSONDecoder()
            
            let dataInfo = try? jsonDecoder.decode(RegisterData.self, from: data)
    
            if(dataInfo?.kq == true){
                // Thanh cong
                print("login thanh cong")
            
                DispatchQueue.main.async{
                    self.defaults.set(dataInfo?.Token, forKey: "UserToken")
                    let alertView = UIAlertController(title: "Thong bao", message: "Login successfully", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "Okay", style: .default,handler:{(action:UIAlertAction!) in
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let dashboard_VC = sb.instantiateViewController(identifier: "DASHBORAD") as! ViewController
                        self.navigationController?.pushViewController(dashboard_VC, animated: false)}))
                        self.present(alertView, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    let alertView = UIAlertController(title: "Thong bao", message: (dataInfo?.errMsg), preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alertView, animated: true, completion: nil)}
                }
            })
        taskUserRegister.resume()
    }
    
}
