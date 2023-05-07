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
    
    let repoService = RepositoryService()
    let imageService = ImageService()
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain , target: self, action: #selector(backTapped(_:)))
        getTextFromImage(image: image!)
        
    }
    
    @objc func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpImage(image: UIImage) {
        self.image = image
    }
    
    private func getTextFromImage(image: UIImage) {
        //let queue = DispatchQueue(label: "MLKitServiceQueue", qos: .userInitiated)
        var recognisedText: String = ""
      
        let mlFunction = MLKitService()
        mlFunction.getText(imageToRecognize: image) { str in
           recognisedText = str
        }
        
        var wines: [Wine] = []
        wines = self.repoService.loadWineByLetters(name: recognisedText)
        print(wines)
        self.nameLabel.text = wines.first?.wine
        self.ratingLabel.text = "\(wines.first?.averageRating)"
        self.locationLabel.text = wines.first?.location
        self.reviewsLabel.text = wines.first?.reviews
        self.imageView.image = self.imageService.downloadImage(url: wines.first?.image)
        self.wineryLabel.text = wines.first?.winery
    }

}
