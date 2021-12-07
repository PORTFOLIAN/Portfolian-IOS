//
//  WritingSaveViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/30.
//

import UIKit
import SnapKit
import Then
import Alamofire

class WritingSaveViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        //                        project}
        //                    completion()
        MyAlamofireManager.shared.getProject(projectID: recruitWriting.newProjectID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let projectInfo):
                print(projectInfo)
            case .failure(let error):
//                self.view.makeToast(error.rawValue, duration: 5.0, position: .center)
                print(error)
        }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
