//
//  CameraVC.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import UIKit

final class CameraVC: UIViewController , GKImagePickerDelegate {
    @IBOutlet private weak var imageView: UIImageView!
    
    private let imagePicker = GKImagePicker()
//    private let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        vc.delegate = self
        imagePicker.delegate = self
        imagePicker.resizeableCropArea = true
        imageView.image = UIImage(named: "emptyBottleOfWine")
        
        imagePicker.accessibilityFrame = CGRect(x: 0, y: view.frame.height - 30, width: view.frame.width, height: 30.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func imagePicker(_ imagePicker: GKImagePicker!, pickedImage image: UIImage!) {
        self.imageView.image = image
        dismiss(animated: (imagePicker.imagePickerController != nil))
    }
    
    func imagePickerDidCancel(_ imagePicker: GKImagePicker!) {
        dismiss(animated: (imagePicker.imagePickerController != nil))
    }
    
    @IBAction func getInfoDidTap() {
        
        if imageView.image != UIImage(named: "emptyBottleOfWine") {
            let wineInfoVC = WineInfoVC(nibName: "\(WineInfoVC.self)", bundle: nil)
            wineInfoVC.setUpImage(image: imageView.image!)
            self.navigationController?.pushViewController(wineInfoVC, animated: true)
        } else {
           
        }
    }
    
    @IBAction func openCameraDidTap() {
//        vc.sourceType = .camera
//        present(vc, animated: true)
    }
    
    @IBAction func openLibraryDidTap() {
        present(imagePicker.imagePickerController, animated: true)
//        vc.sourceType = .photoLibrary
//        present(vc, animated: true)
    }
}
