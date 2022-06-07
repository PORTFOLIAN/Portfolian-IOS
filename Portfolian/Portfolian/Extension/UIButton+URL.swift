//
//  UIButton+URL.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/08.
//

import UIKit

extension UIButton {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    let image = UIImage(data: data)
                    self.setImage(image, for: .normal)
                }
            }
        }).resume()
    }
}
