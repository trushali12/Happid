//
//  ViewController.swift
//  Happid
//
//  Created by mac on 21/05/24.
//

import UIKit

class SplashController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var btnXibView: btnAuthentication!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnXibView.setTitle(titleVal: "Get Started")
        btnXibView.actionBtn.addTarget(self, action: #selector(btnGetStarted), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.setGradientBackground(colorTop: UIColor.gradientOne, colorBottom: UIColor.gradientTwo)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func btnGetStarted() {
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController

        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

