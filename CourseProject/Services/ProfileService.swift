//
//  FunctionalityClass.swift
//  CourseProject
//
//  Created by Allan on 26.01.23.
//

import Foundation
import UIKit
final class ProfileService {
    func verifyAge(birthDay: Date) -> Bool {
//        datePicker.date
        let dateOfBirth = birthDay

        let today = NSDate()

        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        let age = gregorian.components([.year], from: dateOfBirth, to: today as Date , options: [])

        if age.year ?? 18 < 18 {
            return false
        }
        return true
    }
    
    func saveProfileToUserDefaults(profileModel: ProfileModel, profileImage: UIImage) -> String{
        let ud = UserDefaults.standard
        ud.set(profileModel.name, forKey: "name")
        ud.set(profileModel.birthday, forKey: "date")
        let image = profileImage
        var relativePath: String = ""
         //Convert to Data
        let queue = DispatchQueue(label: "ImageDownloadQueue", qos: .default)
        
        
        if let data = image.pngData() {
            // Create URL
            relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate).jpg"
            queue.async { [weak self] in
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent(relativePath)
            do {
                // Write to Disk
                try data.write(to: url)
    
                // Store URL in User Defaults
                UserDefaults.standard.set(relativePath, forKey: "profileImage")

            } catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }}
        return relativePath
    }
    func loadInfoFromUD(_ profileModel: inout ProfileModel){
        let ud = UserDefaults.standard
        let name = ud.string(forKey: "name")
        let dateStr = ud.string(forKey: "date")
        if let relativePath = ud.string(forKey: "profileImage"), let tmp1 = name, let tmp2 = dateStr {
            profileModel.name = tmp1
            profileModel.birthday = tmp2
            profileModel.profileImagePath = relativePath
        }
    }
    func loadPhotoFromUD(relativePath: String?, completion: @escaping ((UIImage?) -> Void)) /* -> UIImage? */{
        let imageService = ImageService()
        var image: UIImage?
        let queue = DispatchQueue(label: "ImageDownloadQueue", qos: .userInteractive)
        if let relativePath = relativePath {
        queue.sync { [weak self] in
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent(relativePath)
            image = imageService.downloadImage(url: url)
            completion(image)
        }
        }
//        return image
    }
    
}
