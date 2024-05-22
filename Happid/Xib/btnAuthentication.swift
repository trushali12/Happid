//
//  btnAuthentication.swift
//  Happid
//
//  Created by mac on 21/05/24.
//

import UIKit

class btnAuthentication: UIView {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setInit()
    }
    
    func setInit(){
        Bundle.main.loadNibNamed("btnAuthentication", owner: self, options: nil)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(mainView)
        mainView.layer.cornerRadius = 5
        mainView.backgroundColor = UIColor(hex: "#5046BB")
    }
    
    func setTitle(titleVal: String){
        self.lblTitle.text = titleVal
    }
}
