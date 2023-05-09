//
//  WineInfoVC.swift
//  CourseProject
//
//  Created by Allan on 25.04.23.
//

import Foundation
import UIKit

final class WineInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let imageService = ImageService()
    private var arrayOfWines: [Wine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerCells()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain , target: self, action: #selector(backTapped(_:)))
    }
    
    private func registerCells(){
        let nib = UINib(nibName: "\(WineInfoTableViewCell.self)", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "\(WineInfoTableViewCell.self)")
    }
    
    @objc func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpArray(arr: [Wine]) {
        self.arrayOfWines = arr
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfWines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(WineInfoTableViewCell.self)") as? WineInfoTableViewCell
        let wine = arrayOfWines[indexPath.row]
        cell?.nameLabel.text = wine.wine
        cell?.avgRatingLabel.text = "\(wine.averageRating)"
        cell?.locationLabel.text = wine.location
        cell?.reviewsLabel.text = wine.reviews
        cell?.wineImage.image = imageService.downloadImage(url: wine.image)
        cell?.wineryLabel.text = wine.winery
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 246
    }

}
