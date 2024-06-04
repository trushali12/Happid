//
//  VerificationViewController.swift
//  Happid
//
//  Created by mac on 22/05/24.
//

import UIKit
import CoreLocation


class VerificationViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var btnSubmitView: btnAuthentication!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    var phoneNumber : String?
    var countryCode : String?
    var otpValue: String!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.setNavigationIten()
        setData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.setGradientBackground(colorTop: UIColor.gradientOne, colorBottom: UIColor.gradientTwo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txt1.becomeFirstResponder()
    }
    
    func setData(){
        btnSubmitView.setTitle(titleVal: "Submit")
        
        btnSubmitView.actionBtn.addTarget(self, action: #selector(btnGetStarted), for: .touchUpInside)
        txt1.delegate = self
        txt2.delegate = self
        txt3.delegate = self
        txt4.delegate = self
        lblPhoneNumber.text = "\(countryCode ?? "") \(phoneNumber ?? "")"
        txt1.addTarget(self, action: #selector(setTextUI1), for: .editingChanged)
        txt2.addTarget(self, action: #selector(setTextUI2), for: .editingChanged)
        txt3.addTarget(self, action: #selector(setTextUI3), for: .editingChanged)
        txt4.addTarget(self, action: #selector(setTextUI4), for: .editingChanged)
        
    }
    
    @IBAction func btnEditNumber(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func generateOTP() -> String{
        return "\(txt1.text ?? "")\(txt2.text ?? "")\(txt3.text ?? "")\(txt4.text ?? "")"
    }
    
    func validation() -> Bool{
        if otpValue == generateOTP(){
            return true
        }else{
            return false
        }
    }
    
    @objc func btnGetStarted() {
        if validation(){
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            vc?.phonumber = self.phoneNumber ?? ""
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            openAleart(msg: "Please Enter Valid OTP", viewcontroller: self)
        }
    }
    
    @objc func pushToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationIten(){
        let button1 = UIBarButtonItem(image: UIImage(named: "back_Arrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(pushToRoot)) //
        self.navigationItem.leftBarButtonItem  = button1
    }
}
extension VerificationViewController: UITextFieldDelegate {
    
    @objc func setTextUI1(txt : UITextField){
        if txt1.text?.count == 1{
            txt2.becomeFirstResponder()
        }
    }
    @objc func setTextUI2(){
        if txt2.text?.count == 1{
            txt3.becomeFirstResponder()
        }
    }
    @objc func setTextUI3(){
        if txt3.text?.count == 1{
            txt4.becomeFirstResponder()
        }
    }
    @objc func setTextUI4(){
        if txt4.text?.count == 1{
            txt4.resignFirstResponder()
        }
    }
}

