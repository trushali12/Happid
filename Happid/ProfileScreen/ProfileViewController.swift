//
//  ProfileViewController.swift
//  Happid
//
//  Created by mac on 22/05/24.
//

import UIKit
import CoreLocation
import MapKit


class ProfileViewController: UIViewController {

    @IBOutlet weak var mMapView: MKMapView!
    @IBOutlet var mainGradientView: UIView!
    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstNameView: textFieldXib!
    @IBOutlet weak var txtLastNameView: textFieldXib!
    @IBOutlet weak var txtPhoneNumberView: textFieldXib!
    @IBOutlet weak var picLocationView: SetCornerRadious!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnSubmitView: btnAuthentication!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    var imagePicker = UIImagePickerController()
    var phonumber : String = ""
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    let manager = CLLocationManager()
    var currentLat : Double = 0.0
    var currentLong : Double = 0.0
    @IBOutlet weak var btnMapClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setNavigationIten()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
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
                URLQueryItem(name: "currentLat", value: "\(self.currentLat)"),
                URLQueryItem(name: "currentLong", value: "\(self.currentLong)")

            ]
            if let url = components.url {
               print(url)
            }else{
                openAleart(msg: URLError(.badURL).localizedDescription, viewcontroller: self)
            }
//            APiCalling()
        }else{
            openAleart(msg: "Please Enter Details", viewcontroller: self)
        }
    }
    
    
    func APiCalling(){ // multi part formdata
        let url = URL(string: "https://www.google.com/search/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        // Add image data
        let image = self.imgProfile.image
        let imageData = image!.jpegData(compressionQuality: 1.0)!
        let filename = "imgProfile.jpg"
        let mimetype = "image/jpeg"

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // Add additional parameters
        let parameters = ["userId": "0", "firstName": "\(txtFirstNameView.txtValue.text ?? "")", "lastName": "\(txtLastNameView.txtValue.text ?? "")", "phoneNumber": "\(txtPhoneNumberView.txtValue.text ?? "")", "postCode": "\(txtPostCode.text ?? "")","currentLat":"\(currentLat)", "currentLong":"\(currentLong)"]
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        // Close the body with the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        print(request.url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error: Invalid HTTP response")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }

        task.resume()
    }
    func setUpUI(){
        locationAuthorization()
        mMapView.showsUserLocation = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        mMapView.addGestureRecognizer(longPressGesture)
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
        mMapView.isHidden = false
        btnMapClose.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnCloseMapView(_ sender: Any) {
        mMapView.isHidden = true
        btnMapClose.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    deinit{
        print("ProfileViewController deinit")
    }
}


extension ProfileViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mMapView.setRegion(mRegion, animated: true)
        // Get user's Current Location and Drop a pin
        mMapView.removeAnnotations(mMapView.annotations)
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
        mMapView.addAnnotation(mkAnnotation)
        self.currentLat = self.mMapView.centerCoordinate.latitude
        self.currentLong = self.mMapView.centerCoordinate.longitude
        self.lblCurrentLocation.text = self.setUsersClosestLocation(mLattitude: self.mMapView.centerCoordinate.latitude, mLongitude: self.mMapView.centerCoordinate.longitude)
        mMapView.isHidden = true
        btnMapClose.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        // Get the location of the tap in the mapView
        let location = gestureRecognizer.location(in: mMapView)
        
        // Convert the location to map coordinates
        let coordinate = mMapView.convert(location, toCoordinateFrom: mMapView)
        
        // Create an annotation
        mMapView.removeAnnotations(mMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.setUsersClosestLocation(mLattitude: mMapView.centerCoordinate.latitude, mLongitude: mMapView.centerCoordinate.longitude)
        // Add the annotation to the map
        mMapView.addAnnotation(annotation)
        self.currentLat = self.mMapView.centerCoordinate.latitude
        self.currentLong = self.mMapView.centerCoordinate.longitude

        let alert = UIAlertController(title: "Alert", message: "You want select this location?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { alert in
            self.mMapView.isHidden = true
            self.btnMapClose.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
            self.lblCurrentLocation.text = self.setUsersClosestLocation(mLattitude: self.mMapView.centerCoordinate.latitude, mLongitude: self.mMapView.centerCoordinate.longitude)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in

            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    if let Name = dict["Name"] as? String{
                        if let City = dict["City"] as? String{
                            self.currentLocationStr = Name + ", " + City
                        }
                    }
                }
            }
        }
        return currentLocationStr
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    //MARK:- Intance Methods
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        }
        
    }
    
    func locationAuthorization(){
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Authorized")
            determineCurrentLocation()
        case .denied:
           break
        case .authorizedAlways:
            determineCurrentLocation()
        case.notDetermined:
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
            sleep(2)
            locationAuthorization()
        default:
            break
        }
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
