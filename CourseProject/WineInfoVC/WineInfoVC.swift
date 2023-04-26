//
//  WineInfoVC.swift
//  CourseProject
//
//  Created by Allan on 25.04.23.
//

import Foundation
import UIKit

final class WineInfoVC: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var wineryLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var reviewsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain , target: self, action: #selector(backTapped(_:)))
    }
    
    @objc func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpImage(image: UIImage) {
        getTextFromImage(image: image)
    }
    
    private func getTextFromImage(image: UIImage) {
        DispatchQueue.main.async {
            let mlFunction = MLKitService()
            mlFunction.getText(imageToRecognize: image)
        }
    }
}
