//
//  OTPViewController.swift
//  Happid
//
//  Created by mac on 21/05/24.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var mainCenterView: UIView!
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var bgView: UIView!
    var navigationVC : LoginViewController?
    
    var otpValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCenterView.layer.cornerRadius = 10
        setData()
    }
    
    
    func setData(){
        var otpDisplay : String = ""
        for val in otpValue{
            otpDisplay.append("\(val)   ")
        }
        txtOtp.text = otpDisplay
    }

    @IBAction func bgButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.navigationVC?.openVerificationVC(otpVal: self.otpValue)
        }
    }

}
