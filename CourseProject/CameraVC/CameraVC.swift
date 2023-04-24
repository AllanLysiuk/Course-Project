//
//  CameraVC.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import UIKit

final class CameraVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    @IBOutlet private weak var imageView: UIImageView!
    
    private let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        vc.allowsEditing = true
        imageView.image = UIImage(named: "emptyBottleOfWine")
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
        
        if imageView.image == UIImage(named: "emptyBottleOfWine") {
            print("bad")
        } else {
            print("Good")
        }
    }
    
    @IBAction func openCameraDidTap() {
        vc.sourceType = .camera
        present(vc, animated: true)
    }
    
    @IBAction func openLibraryDidTap() {
        vc.sourceType = .photoLibrary
        present(vc, animated: true)
    }
}
