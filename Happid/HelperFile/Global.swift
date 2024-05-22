//
//  Constant.swift
//  Happid
//
//  Created by mac on 21/05/24.
//

import Foundation
import UIKit


let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)

class SetCornerRadious : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setInit()
    }
    
    func setInit(){
        self.layer.cornerRadius = 5
    }
}


func openAleart(msg:  String, viewcontroller: UIViewController){
    let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
    viewcontroller.present(alert, animated: true, completion: nil)
}


