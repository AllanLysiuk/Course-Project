//
//  CameraVC.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import UIKit

final class CameraVC: UIViewController, UIImagePickerControllerDelegate , GKImagePickerDelegate, UINavigationControllerDelegate{
    @IBOutlet private weak var imageView: UIImageView!
    
    private let imagePicker = GKImagePicker()
//    private let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        vc.delegate = self
        imagePicker.delegate = self
        imagePicker.resizeableCropArea = true
        imageView.image = UIImage(named: "emptyBottleOfWine")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        imageView.image = image
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
  
//        vc.sourceType = .photoLibrary
//        present(vc, animated: true)
    }
}
