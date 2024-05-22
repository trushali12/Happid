//
//  ProfileViewController.swift
//  Happid
//
//  Created by mac on 22/05/24.
//

import UIKit


class ProfileViewController: UIViewController {

    @IBOutlet var mainGradientView: UIView!
    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstNameView: textFieldXib!
    @IBOutlet weak var txtLastNameView: textFieldXib!
    @IBOutlet weak var txtPhoneNumberView: textFieldXib!
    @IBOutlet weak var picLocationView: SetCornerRadious!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnSubmitView: btnAuthentication!
    var imagePicker = UIImagePickerController()
    var phonumber : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setNavigationIten()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainGradientView.setGradientBackground(colorTop: UIColor.gradientOne, colorBottom: UIColor.gradientTwo)
        mainProfileView.layer.cornerRadius = mainProfileView.frame.size.height/2
    }
    
    @objc func pushToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNavigationIten(){
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "Create profile"
        let button1 = UIBarButtonItem(image: UIImage(named: "back_Arrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(pushToRoot)) //
        self.navigationItem.leftBarButtonItem  = button1
    }
    
    func validation() -> Bool{
        if txtFirstNameView.txtValue.text == ""{
            openAleart(msg: "Please Enter First Name", viewcontroller: self)
        }else if txtLastNameView.txtValue.text == ""{
            openAleart(msg: "Please Enter Last Name", viewcontroller: self)
        }else if txtPhoneNumberView.txtValue.text == ""{
            openAleart(msg: "Please Enter Phone Number OTP", viewcontroller: self)
        }else if txtPostCode.text == ""{
            openAleart(msg: "Please Enter Post Code", viewcontroller: self)
        }else{
            return true
        }
        return false
    }
    
    @objc func btnGetStarted() {
        if validation(){
            var components = URLComponents(string: "https://www.google.com/search/")!
            components.queryItems = [
                URLQueryItem(name: "userId", value: "0"),
                URLQueryItem(name: "firstName", value: "\(txtFirstNameView.txtValue.text ?? "")"),
                URLQueryItem(name: "lastName", value: "\(txtLastNameView.txtValue.text ?? "")"),
                URLQueryItem(name: "phoneNumber", value: "\(txtPhoneNumberView.txtValue.text ?? "")"),
                URLQueryItem(name: "postCode", value: "\(txtPostCode.text ?? "")"),
            ]
            if let url = components.url {
               print(url)
            }else{
                openAleart(msg: URLError(.badURL).localizedDescription, viewcontroller: self)
            }
        }else{
            openAleart(msg: "Please Enter Details", viewcontroller: self)
        }
    }
    
    func setUpUI(){
        imagePicker.delegate = self
        txtPhoneNumberView.txtValue.text = phonumber
        txtPhoneNumberView.txtValue.isEnabled = false
        btnSubmitView.setTitle(titleVal: "Submit")
        btnSubmitView.actionBtn.addTarget(self, action: #selector(btnGetStarted), for: .touchUpInside)
        txtFirstNameView.lblTitile.text = "First name"
        txtLastNameView.lblTitile.text = "Last Name"
        txtPhoneNumberView.lblTitile.text = "Phone"
        txtPhoneNumberView.txtBgView.layer.borderColor = UIColor.orangeThemeColor.cgColor
        txtPhoneNumberView.txtBgView.layer.borderWidth = 1
    }
    
    @IBAction func picProfileActionBtn(_ sender: UIButton) {
        openPicker(sender)
    }
    
    @IBAction func selectLocation(_ sender: UIButton) {
        
    }
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
    func openPicker(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
               self.openCamera()
           }))
           
           alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
               self.openGallary()
           }))
           
           alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
           
           //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
           switch UIDevice.current.userInterfaceIdiom {
           case .pad:
               alert.popoverPresentationController?.sourceView = sender
               alert.popoverPresentationController?.sourceRect = sender.bounds
               alert.popoverPresentationController?.permittedArrowDirections = .up
           default:
               break
           }
           self.present(alert, animated: true, completion: nil)
    }
    
    // Open the camera
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    /// Choose image from camera roll
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        // If you don't want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the image from the info dictionary.
        if let editedImage = info[.editedImage] as? UIImage {
            self.imgProfile.image = editedImage
        }
        
        // Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
