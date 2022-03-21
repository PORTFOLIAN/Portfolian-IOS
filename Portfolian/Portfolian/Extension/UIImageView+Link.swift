//
//  UIImageView.swift
//  Portfolian
//
//  Created by 이상현 on 2022/03/20.
//

import UIKit

//extension UIImageView {
//    // [링크에서 이미지를 가져와서 이미지뷰에 넣어주는 함수]
//    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
//        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
//            (data, response, error) -> Void in
//            DispatchQueue.main.async { [weak self] in
//                self?.contentMode =  contentMode
//                if let data = data {
//                    let image = UIImage(data: data)
//                    self?.image = image
//                }
//            }
//        }).resume()
//    }
//}
