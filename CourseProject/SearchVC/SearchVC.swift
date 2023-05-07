//
//  SearchVC.swift
//  CourseProject
//
//  Created by Allan on 22.01.23.
//

import UIKit

final class SearchVC: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    let arrOfWineTypes: [WineType] = [.red, .white, .sparkling, .rose, .dessert, .port]
    let repoService = RepositoryService()
    let imageService = ImageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        //searchBar?.delegate = self
        collectionView.insetsLayoutMarginsFromSafeArea = false
        registerCells()
       repoService.updateCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func registerCells(){
        let nib1 = UINib(nibName: "\(TypeCollectionViewCell.self)", bundle: nil)
        collectionView.register(nib1, forCellWithReuseIdentifier: "\(TypeCollectionViewCell.self)")
        let nib2 = UINib(nibName: "\(SearchBarVCCell.self)", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "\(SearchBarVCCell.self)")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            print(arrOfWineTypes.count)
            return arrOfWineTypes.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SearchBarVCCell.self)", for: indexPath) as? SearchBarVCCell
            return cell ?? UICollectionViewCell()
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TypeCollectionViewCell.self)", for: indexPath) as? TypeCollectionViewCell
            let wineType = arrOfWineTypes[indexPath.row]
            cell?.typeLabel.text = wineType.rawValue
            cell?.backgroundImage.image = imageService.getImageByType(type: wineType)
            
            return cell ?? UICollectionViewCell()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let svc = SearchBarVC(nibName: "\(SearchBarVC.self)", bundle: nil)
            self.navigationController?.pushViewController(svc, animated: true)
        }else {
            let nextVC = WineTypeSearchVC(nibName: "\(WineTypeSearchVC.self)", bundle: nil)
            nextVC.selectedTypeOfWine = arrOfWineTypes[indexPath.row]
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize
        if indexPath.section == 0{
            let collectionWidth = collectionView.frame.width
            cellSize = CGSize(width: collectionWidth , height: 350)
        }else{
            let collectionWidth = collectionView.frame.width
            cellSize = CGSize(width: (collectionWidth / 2) - 1 , height: (collectionWidth / 2) - 2)
        }
        return cellSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -48, left: 0, bottom: 0, right: 0)
    }
    
}
