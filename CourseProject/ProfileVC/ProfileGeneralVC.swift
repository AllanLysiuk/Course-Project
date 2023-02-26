//
//  ProfileGeneralVC.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import Foundation
import UIKit
final class ProfileGeneralVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EditProfileGeneralVCDelegate{
  
    @IBOutlet private weak var buttonSettings: UIButton!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var labelWelcome: UILabel!{
        didSet{
            let ud = UserDefaults.standard
            if let name = ud.string(forKey: "name"){
                self.labelWelcome.text = "Welcome back, \(name)!"
            }else{
                self.labelWelcome.text = "Welcome back, User!"
            }
        }
    }
    @IBOutlet private weak var profileImage: UIImageView!{
        didSet{
            let ud = UserDefaults.standard
            if let imagePath = ud.string(forKey: "profileImage"){
                functions.loadPhotoFromUD(relativePath: imagePath){ image in
                    self.profileImage.image = image
                }
            } else{
                profileImage.image = UIImage(named: "emptyBottleOfWine")
            }
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            profileImage.contentMode = .scaleToFill
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    
    private var arrOfFav: [Wine] = []
    private var arrOfTryLater: [Wine] = []
    let functions = ProfileService()
    let repoService = RepositoryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        topView.backgroundColor = UIColor(red: 221/255, green: 21/255, blue: 51/255, alpha: 1)
        registerCells()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrOfFav = repoService.loadFavWines()
        arrOfTryLater = repoService.loadTryLaterWines()
        tableView.reloadData()
    }
    
    private func registerCells(){
        let nib = UINib(nibName: "\(ProfileTableViewCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "\(ProfileTableViewCell.self)")
    }
    
    func UserDidSelect(text: String, image: UIImage) {
        labelWelcome.text = "Welcome back, \(text)!"
        profileImage.image = image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return categories.count
        return 2
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ProfileTableViewCell.self)", for: indexPath) as? ProfileTableViewCell
        let category: String
        let counter: Int
        if indexPath.row == 0{
            category = "Favourite Wines"
            counter = arrOfFav.count
        }else{
            category = "Try Later"
            counter = arrOfTryLater.count
        }
        cell?.categoryLabel.text = "\(category)"
        cell?.counterLabel.text = "\(counter)"
        return cell ?? UITableViewCell()
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = SavedWinesVC(nibName: "\(SavedWinesVC.self)", bundle: nil)
        if indexPath.row == 0{
            nextVC.typeOfSavingCategory = .favorite
        }else{
            nextVC.typeOfSavingCategory = .tryLater
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction private func buttonSetingsDidTap(){
        let settingsVC = ProfileSettingsVC(nibName: "\(ProfileSettingsVC.self)", bundle: nil)
        settingsVC.modalPresentationStyle = .fullScreen
        settingsVC.delegate = self
        present(settingsVC, animated: true, completion: nil)
    }
   
}

