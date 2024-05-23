//
//  LoginViewController.swift
//  Happid
//
//  Created by mac on 21/05/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var imgCountryFlage: UIImageView!
   
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var btnRequestOtpView: btnAuthentication!
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
    @IBOutlet weak var btnLoginWithFaceBook: UIButton!
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationIten()
        self.setupData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.setGradientBackground(colorTop: UIColor.gradientOne, colorBottom: UIColor.gradientTwo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtPhoneNumber.becomeFirstResponder()
    }
    
    
    func setupData(){
        txtPhoneNumber.keyboardType = .phonePad
        btnRequestOtpView.setTitle(titleVal: "Request OTP")
        btnRequestOtpView.actionBtn.addTarget(self, action: #selector(btnGetStarted), for: .touchUpInside)
        txtPhoneNumber.delegate = self
    }
    
    @IBAction func selectCountry(_ sender: UIButton) {
        
        
    }
    
    func validateNumber() -> Bool{
        if (txtPhoneNumber.text != "") && validateMobileNumber(value: txtPhoneNumber.text ?? ""){
            return true
        }
        return false
    }
    
    func generateOTP() -> String{
        return "\(txtPhoneNumber.text?.prefix(2) ?? "00")\(txtPhoneNumber.text?.suffix(2) ?? "00")"
    }
    
    @objc func btnGetStarted() {
        txtPhoneNumber.resignFirstResponder()
        if validateNumber(){
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.otpValue = generateOTP()
            vc.navigationVC = self
            self.present(vc, animated: false)
        }else{
            openAleart(msg: "Please Entervalid Number", viewcontroller: self)
        }
    }
    
    
    
    func validateMobileNumber(value: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9]\\d{9}$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) != nil
        print("Mobile validation \(valid)")
        return valid
    }
   
    func openVerificationVC(otpVal: String){
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
        vc.phoneNumber = "\(txtPhoneNumber.text ?? "")"
        vc.countryCode = "\(lblCountryCode.text ?? "")"
        vc.otpValue = otpVal
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationIten(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        let button1 = UIBarButtonItem(image: UIImage(named: "back_Arrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(pushToRoot)) //
        self.navigationItem.leftBarButtonItem  = button1
    }

}

extension LoginViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
