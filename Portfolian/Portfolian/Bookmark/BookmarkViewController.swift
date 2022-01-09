//
//  BookmarkViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/19.
//

import UIKit

class BookmarkViewController: UIViewController {
    lazy var logo: UIBarButtonItem = {
        let image = UIImage(named: "Logo")?.resizeImage(size: CGSize(width: 150, height: 30)).withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 1
        return button
    }()
    
    lazy var filter: UIBarButtonItem = {
        let image = UIImage(named: "Filter")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 2
        return button
    }()
    
    lazy var push: UIBarButtonItem = {
        let image = UIImage(named: "Push")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 3
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLogo()
        setUpItem()
        tableView.delegate = self
        tableView.dataSource = self
        subview()
        constraints()
        
        
        // Do any additional setup after loading the view.
    }
    
    // Mark: SetupLogo
    func setUpLogo() {
        navigationItem.leftBarButtonItem = logo
    }
    
    func setUpItem() {
        navigationItem.rightBarButtonItems = [push, filter]
    }
    
    //MARK: - ButtonPressed
    @objc private func barButtonPressed(_ sender: UIBarButtonItem) {
        
        switch sender.tag {
        case 1: // logo
            
            let HomeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
            HomeVC.modalPresentationStyle = .fullScreen
            self.dismiss(animated: true, completion: nil)
            
        case 2: // filter
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            FilterVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(FilterVC, animated: true)
        case 3: // push
            print(4)
        default:
            print("error")
            
        }
    }
    
    // MARK: - disappear barButton
    
    func disappearBarButton() {
        navigationItem.leftBarButtonItems = nil
        navigationItem.rightBarButtonItems = nil
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
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

extension BookmarkViewController: BookmarkButtonDelegate {
    func didTouchBookmarkButton(didClicked: Bool, sender: UIButton) {
        print("success")
    }
}

extension BookmarkViewController {
    func subview() {
        view.addSubview(tableView)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}


extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0;//Choose your custom row height
    }
}
