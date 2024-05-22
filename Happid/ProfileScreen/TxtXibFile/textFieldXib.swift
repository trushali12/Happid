//
//  textFieldXib.swift
//  Happid
//
//  Created by mac on 22/05/24.
//

import UIKit

class textFieldXib: UIView {

    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var lblTitile: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var txtBgView: SetCornerRadious!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setInit()
    }
    func setInit(){
        Bundle.main.loadNibNamed("textFieldXib", owner: self, options: nil)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(mainView)
        mainView.layer.cornerRadius = 5
//        mainView.backgroundColor = UIColor(hex: "#5046BB")
    }
}
