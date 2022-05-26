//
//  HomeViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/19.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    lazy var logo: UIBarButtonItem = {
        let image = UIImage(named: "Logo")?.resizeImage(size: CGSize(width: 150, height: 30)).withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 1
        return button
    }()
    
    lazy var search: UIBarButtonItem = {
        let image = UIImage(named: "Search")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 2
        return button
    }()
    
    lazy var filter: UIBarButtonItem = {
        let image = UIImage(named: "Filter")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 3
        return button
    }()
    
    lazy var push: UIBarButtonItem = {
        let image = UIImage(named: "Push")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 4
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        return tableView
    }()
    
    lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Write")?.resizeImage(size: CGSize(width: 80, height: 80)), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        //        self.navigationItem.largeTitleDisplayMode = .automatic
        setUpLogo()
        setUpItem()
        tableView.delegate = self
        tableView.dataSource = self
        subview()
        constraints()
    }
    
    // Mark: SetupLogo
    func setUpLogo() {
        navigationItem.leftBarButtonItem = logo
    }
    
    func setUpItem() {
        navigationItem.rightBarButtonItems = [push, filter, search]
    }
    
    //MARK: - ButtonPressed
    @objc private func barButtonPressed(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1: // logo
            let HomeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
            HomeVC.modalPresentationStyle = .fullScreen
            self.dismiss(animated: true, completion: nil)
            
        case 2: // search
            disappearBarButton()
            configureSearchController()
            
        case 3: // filter
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            FilterVC.modalPresentationStyle = .fullScreen
            registrationType = .Searching
            self.navigationController?.pushViewController(FilterVC, animated: true)
        case 4: // push
            print(4)
        default:
            print("error")
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        let WritingVC = UIStoryboard(name: "Writing", bundle: nil).instantiateViewController(withIdentifier: "WritingVC")
        WritingVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(WritingVC, animated: true)
    }
    
    
    
    //MARK: - Search bar
    func configureSearchController(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        // 텍스트가 변경되는것을 알립니다.
        searchController.searchResultsUpdater = self
        // 흐려지는걸 원하지 않습니다.
        searchController.obscuresBackgroundDuringPresentation = false
        // 리턴키를 "완료"로 합니다.
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        navigationItem.titleView = searchController.searchBar
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.searchBar.placeholder = "검색하삼"
        // 사용자가 다른 뷰 컨트롤러로 이동하면 search bar가 화면에 남아 있지 않도록 합니다.
        definesPresentationContext = true
        // 플레이스홀더를 설정합니다.
    }
    
    // MARK: - disappear barButton
    func disappearBarButton() {
        navigationItem.leftBarButtonItems = nil
        navigationItem.rightBarButtonItems = nil
    }
    
    // MARK: - Search bar cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.searchController = nil
        self.navigationItem.titleView = nil
        setUpItem()
        setUpLogo()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        
        
    }
}
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    extension HomeViewController: BookmarkButtonDelegate {
        func didTouchBookmarkButton(didClicked: Bool) {
            
            
        }
    }
    
    extension HomeViewController {
        func subview() {
            view.addSubview(tableView)
            view.addSubview(writeButton)
        }
        
        func constraints() {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                writeButton.bottomAnchor.constraint(equalTo: tableView.frameLayoutGuide.bottomAnchor, constant: -20),
                writeButton.trailingAnchor.constraint(equalTo: tableView.frameLayoutGuide.trailingAnchor, constant: -20),
            ])
        }
    }
    
    extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
        // 셀의 개수
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
            cell.cellDelegate = self
            return cell
        }
        
        // 셀이 선택 되었을 때
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(indexPath)
        }
        
        
        // 셀의 크기 지정
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150.0;//Choose your custom row height
        }
        
    }
