//
//  ProfileSettingsVC.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import Foundation
import UIKit



final class ProfileSettingsVC: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private weak var imageInfoLabel: UILabel!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var profileImage: UIImageView!{
        didSet{
            profileImage.isUserInteractionEnabled = true
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            profileImage.contentMode = .scaleToFill
        }
    }
    @IBOutlet private weak var nameTextField: UITextField!{
        didSet{
            nameTextField.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet private weak var dateTextField: UITextField!{
        didSet{
            dateTextField.layer.cornerRadius = 10.0
        }
    }
    
    private var datePicker: UIDatePicker!
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private let functions = ProfileService()
    var profileModel = ProfileModel()
    var delegate: EditProfileGeneralVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        dateTextField.delegate = self
        
        datePicker = generateDatePicker(with: .date)
        dateTextField.inputView = datePicker
        
        topView.backgroundColor = UIColor(red: 221/255, green: 21/255, blue: 51/255, alpha: 1)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(didTapOnView(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.profileImage.addGestureRecognizer(tapGesture)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        functions.loadInfoFromUD(&profileModel)
        updateUI(profileModel.name, profileModel.birthday, profileModel.profileImagePath)
    }
    
    //updateUI   ->
    private func updateUI(_ name: String, _ dateStr: String, _ relativePath: String?){
        nameTextField.text = name
        dateTextField.text = dateStr
        datePicker.date = dateFormatter.date(from: dateTextField.text!)!//Fix force unwrap
        
       functions.loadPhotoFromUD(relativePath: relativePath) { image in
            self.profileImage.image = image
        }
        if profileImage.image != nil{
            imageInfoLabel.text = nil
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.layer.borderWidth = 0
        return true
    }
    
    
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    func showImagePicker(){
        let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
        libraryImagePicker.delegate = self
        self.present(libraryImagePicker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.profileImage.image = image
        if profileImage.image != nil{
            imageInfoLabel.text = nil
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    
    private func generateDatePicker(with mode: UIDatePicker.Mode) -> UIDatePicker{
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateDidChanged(_:)), for: .valueChanged)
        return datePicker
    }
    @objc private func dateDidChanged(_ sender: UIDatePicker){
        let selectedDate = sender.date
        dateTextField.text = dateFormatter.string(from: selectedDate)
    }
    @objc private func didTapOnView(_ gesture: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Source",
                                      message: "Select what you want",
                                      preferredStyle: .actionSheet)
        
        let okButton = UIAlertAction(title: "Open Gallery",
                                     style: .default) { _ in
            self.showImagePicker()
        }
        alert.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel) { _ in
        }
        alert.addAction(cancelButton)
        
        
        present(alert, animated: true)
    }
    
    
    //MultiThreading!!!!!!!!
    private func textFieldHasError() -> Bool{
        var hasError = false
        if !nameTextField.hasText {
            nameTextField.layer.borderWidth = 2
            nameTextField.layer.borderColor = UIColor.red.cgColor
            // nameTextField.layer.cornerRadius = 10.0
            hasError = true
        }
        if !dateTextField.hasText {
            dateTextField.layer.borderWidth = 2
            dateTextField.layer.borderColor = UIColor.red.cgColor
            //nameTextField.layer.cornerRadius = 10.0
            hasError = true
        }
        if !functions.verifyAge(birthDay:  datePicker.date){
            let alert = UIAlertController(title: "Error!",
                                          message: "You can't use this app if you are less than 18 years old",
                                          preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Ok",
                                         style: .default) { _ in
            }
            alert.addAction(okButton)
            present(alert, animated: true)
            hasError = true
        }
        return hasError
    }
    
    @IBAction private func buttonSaveDidTap(){
        if textFieldHasError(){
            return
        }else{
            profileModel.name = nameTextField.text!
            profileModel.birthday = dateTextField.text!
            let relativePath = functions.saveProfileToUserDefaults(profileModel: profileModel, profileImage: profileImage.image ?? UIImage())
            profileModel.profileImagePath = relativePath
            delegate?.UserDidSelect(text: profileModel.name, image: (profileImage.image ?? UIImage(named: "emptyBottleOfWine"))!)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
