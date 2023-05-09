//
//  CameraVC.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import UIKit

final class CameraVC: UIViewController , GKImagePickerDelegate {
    @IBOutlet private weak var imageView: UIImageView!
    
    private let repoService = RepositoryService()
    private let imagePicker = GKImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            var recognisedText: String = ""
            let mlFunction = MLKitService()
            let group = DispatchGroup()
            group.enter()
            mlFunction.getText(imageToRecognize: imageView.image!) { str in
               recognisedText = str
                group.leave()
            }
            group.notify(queue: .main) {
                let alertVC = UIAlertController(title: "Recognised Text: *\(recognisedText)*",
                                                message: "Is recognised text correct? If it is not try to change crop area of image",
                                                preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    let wines = self.getArrayOfWines(text: recognisedText)
                    if wines.isEmpty {
                        let alertProblemVC = UIAlertController(title: "Something went wrong",
                                                        message: "We couldn't find wines with this names. Try to take another photo",
                                                        preferredStyle: .alert)
                        let okey = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            alertProblemVC.dismiss(animated: true)
                        })
                        alertProblemVC.addAction(okey)
                        self.present(alertProblemVC, animated: true)
                    } else {
                        let wineInfoVC = WineInfoVC(nibName: "\(WineInfoVC.self)", bundle: nil)
                        wineInfoVC.setUpArray(arr: wines)
                        self.navigationController?.pushViewController(wineInfoVC, animated: true)
                    }
                })
              
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    alertVC.dismiss(animated: true)
                }
                alertVC.addAction(ok)
                alertVC.addAction(cancel)
                self.present(alertVC, animated: true)
            }
        } else {
           
        }
    }
    
    private func getArrayOfWines(text: String) -> [Wine] {
        var wines: [Wine] = []
        wines = self.repoService.loadWineByLettersWinery(name: text)
        if wines.isEmpty {
            wines = self.repoService.loadWineByLetters(name: text)
        }
        if wines.isEmpty {
            wines = self.repoService.loadWineByName(name: text)
        }
        return wines
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
