//
//  HomeViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/19.
//

import UIKit
import Then
import SnapKit
import Alamofire
import MapKit
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
    
    lazy var viewsCheckBox = UIButton().then({ UIButton in
        UIButton.setImage(UIImage(named: "Checkbox"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    })
    
    lazy var viewsLabel = UILabel().then({ UILabel in
        UILabel.text = "조회 순"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    })
    lazy var latestCheckBox = UIButton().then({ UIButton in
        UIButton.setImage(UIImage(named: "CheckboxFill"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    })
    
    lazy var latestLabel = UILabel().then({ UILabel in
        UILabel.text = "최신 순"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    })
    
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
    
    let refreshControl = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SEARCHTOGGLE {
            var projectSearch: ProjectSearch
            if let keyword = searchingTag.names.first?.rawValue {
                projectSearch = ProjectSearch(stack: keyword, sort: "default", keyword: "default")
            } else {
                projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
            }
            MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.setNeedsLayout()
                }
            }
        } else {
            let projectSearch = ProjectSearch(stack: "default", sort: "view", keyword: "default")
            MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.setNeedsLayout()
                }
            }
        }
        if REFRESHTOKEN != "" {
            MyAlamofireManager.shared.renewAccessToken() { bool in
                if !bool {
                    let vc = SettingViewController()
                    vc.goToApp()
                }
            }
        } else {
            let vc = SettingViewController()
            vc.goToApp()
        }
    }
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
        initRefresh()
        editType = .yet
//        self.tableView.separatorStyle = .none
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
            registrationType = .Searching
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            self.navigationController?.pushViewController(FilterVC, animated: true)
            
        case 4: // push
            print(4)
            
        default:
            print("error")
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case writeButton:
            let WritingVC = UIStoryboard(name: "Writing", bundle: nil).instantiateViewController(withIdentifier: "WritingVC")
            WritingVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(WritingVC, animated: true)
        case viewsCheckBox:
            if SEARCHTOGGLE {
                SEARCHTOGGLE.toggle()
                viewsCheckBox.setImage(UIImage(named: "CheckboxFill"), for: .normal)
                latestCheckBox.setImage(UIImage(named: "Checkbox"), for: .normal)
                let projectSearch = ProjectSearch(stack: "default", sort: "view", keyword: "default")
                MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.setNeedsLayout()
                    }
                }
            }
            
        case latestCheckBox:
            if !SEARCHTOGGLE {
                SEARCHTOGGLE.toggle()
                latestCheckBox.setImage(UIImage(named: "CheckboxFill"), for: .normal)
                viewsCheckBox.setImage(UIImage(named: "Checkbox"), for: .normal)
                
                let projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
                MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.setNeedsLayout()
                    }
                }
            }
        case refreshControl:
            print("새로고침 시작")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }

        default:
            break
        }
        
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
        searchController.searchBar.placeholder = "원하시는 프로젝트를 검색해보세요"
        // 사용자가 다른 뷰 컨트롤러로 이동하면 search bar가 화면에 남아 있지 않도록 합니다.
        definesPresentationContext = true
        // 플레이스홀더를 설정합니다.
    }
    
    func initRefresh() {
            refreshControl.addTarget(self, action: #selector(buttonPressed(_:)), for: .valueChanged)
            refreshControl.attributedTitle = NSAttributedString(string: "새 프로젝트를 찾는 중입니다:)")
            tableView.refreshControl = refreshControl
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: searchText)
            MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.setNeedsLayout()
                }
            }
        } else {
            let projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
            MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.setNeedsLayout()
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(2)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(1)
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
    func didTouchBookmarkButton(didClicked: Bool, sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint(x: 5, y: 5), to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let articleList = projectListInfo.articleList
        let articleInfo = articleList[indexPath?[1] ?? 0]
        let projectId = articleInfo.projectId
        var bookMarked = articleInfo.bookMark
        bookMarked.toggle()
        let bookmark = Bookmark(projectId: projectId, bookMarked: bookMarked)
        MyAlamofireManager.shared.postBookmark(bookmark: bookmark) { result in
            if SEARCHTOGGLE {
                var projectSearch: ProjectSearch
                if let keyword = searchingTag.names.first?.rawValue {
                    projectSearch = ProjectSearch(stack: keyword, sort: "default", keyword: "default")
                } else {
                    projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
                }
                MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.setNeedsLayout()
                    }
                }
            } else {
                let projectSearch = ProjectSearch(stack: "default", sort: "view", keyword: "default")
                MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.setNeedsLayout()
                    }
                }
            }
        }
    }
}

extension HomeViewController {
    func subview() {
        view.addSubview(tableView)
        view.addSubview(writeButton)
        view.addSubview(viewsCheckBox)
        view.addSubview(viewsLabel)
        view.addSubview(latestCheckBox)
        view.addSubview(latestLabel)
    }
    
    func constraints() {
        latestLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        latestCheckBox.snp.makeConstraints { make in
            make.height.width.equalTo(15)
            make.centerY.equalTo(latestLabel)
            make.trailing.equalTo(latestLabel.snp.leading).offset(-10)
        }
        
        viewsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(latestCheckBox)
            make.trailing.equalTo(latestCheckBox.snp.leading).offset(-10)
        }
        
        viewsCheckBox.snp.makeConstraints { make in
            make.height.width.equalTo(15)
            make.centerY.equalTo(viewsLabel)
            make.trailing.equalTo(viewsLabel.snp.leading).offset(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(viewsCheckBox.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        writeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(tableView.frameLayoutGuide)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    // 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return projectListInfo.articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.cellDelegate = self
        let articleList = projectListInfo.articleList
        let articleInfo = articleList[indexPath[1]]
        cell.titleLabel.text = articleInfo.title
        let lenStackList = articleInfo.stackList.count
        let stringTag = articleInfo.stackList
        let bookmark = articleInfo.bookMark

        URLSession.shared.dataTask( with: NSURL(string:articleInfo.leader.photo)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async { [weak self] in
                cell.profileImageView.contentMode =  .scaleToFill
                if let data = data {
                    let image = UIImage(data: data)
                    cell.profileImageView.image = image
                }
            }
        }).resume()

        if bookmark == true {
            cell.bookmarkButton.setImage(UIImage(named: "BookmarkFill")?.resizeImage(size: CGSize(width: 15, height: 20)), for: .normal)
        } else {
            cell.bookmarkButton.setImage(UIImage(named: "Bookmark2")?.resizeImage(size: CGSize(width: 15, height: 20)), for: .normal)
        }
        var labelStackCount: Int = 0
        var tagInfo1, tagInfo2, tagInfo3: TagInfo
        
        cell.tagButton1.informTextInfo(text: "", fontSize: 16)
        cell.tagButton1.currentColor(color: .clear)
        cell.tagButton2.informTextInfo(text: "", fontSize: 16)
        cell.tagButton2.currentColor(color: .clear)
        cell.tagButton3.informTextInfo(text: "", fontSize: 16)
        cell.tagButton3.currentColor(color: .clear)
        cell.numberOftagsLabel.text = ""
        switch lenStackList {
        case 1:
            tagInfo1 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[0]))
            cell.tagButton1.informTextInfo(text: tagInfo1.name, fontSize: 16)
            cell.tagButton1.currentColor(color: tagInfo1.color)
            
        case 2:
            tagInfo1 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[0]))
            tagInfo2 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[1]))
            cell.tagButton1.informTextInfo(text: tagInfo1.name, fontSize: 16)
            cell.tagButton1.currentColor(color: tagInfo1.color)
            cell.tagButton2.informTextInfo(text: tagInfo2.name, fontSize: 16)
            cell.tagButton2.currentColor(color: tagInfo2.color)
            
        case 3:
            tagInfo1 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[0]))
            tagInfo2 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[1]))
            tagInfo3 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[2]))
            cell.tagButton1.informTextInfo(text: tagInfo1.name, fontSize: 16)
            cell.tagButton1.currentColor(color: tagInfo1.color)
            cell.tagButton2.informTextInfo(text: tagInfo2.name, fontSize: 16)
            cell.tagButton2.currentColor(color: tagInfo2.color)
            cell.tagButton3.informTextInfo(text: tagInfo3.name, fontSize: 16)
            cell.tagButton3.currentColor(color: tagInfo3.color)
            
        default:
            labelStackCount = lenStackList - 3
            tagInfo1 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[0]))
            tagInfo2 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[1]))
            tagInfo3 = Tag.shared.getTagInfo(tag: Tag.Name(rawValue: stringTag[2]))
            cell.tagButton1.informTextInfo(text: tagInfo1.name, fontSize: 16)
            cell.tagButton1.currentColor(color: tagInfo1.color)
            cell.tagButton2.informTextInfo(text: tagInfo2.name, fontSize: 16)
            cell.tagButton2.currentColor(color: tagInfo2.color)
            cell.tagButton3.informTextInfo(text: tagInfo3.name, fontSize: 16)
            cell.tagButton3.currentColor(color: tagInfo3.color)
            cell.numberOftagsLabel.text = "+ \(labelStackCount)"
        }
        cell.viewsLabel.text = "조회 \(articleInfo.view)"
        return cell
    }
    
    // 셀이 선택 되었을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
        
        let articleList = projectListInfo.articleList
        let articleInfo = articleList[indexPath[1]]
        let projectId = articleInfo.projectId
        recruitWriting.newProjectID = projectId
        MyAlamofireManager.shared.getProject(projectID: projectId) { result in
            switch result {
            case .success:
                writingTeamTag.names = []
                writingOwnerTag.names = []
                for tag in projectInfo.stackList{
                    guard let tagName = Tag.Name(rawValue: tag) else { return }
                    writingTeamTag.names.append(tagName)
                }
                guard let tagName = Tag.Name(rawValue: projectInfo.leader.stack) else { return }
                writingOwnerTag.names.append(tagName)
                let WritingSaveVC = UIStoryboard(name: "WritingSave", bundle: nil).instantiateViewController(withIdentifier: "WritingSaveVC")
                self.navigationController?.pushViewController(WritingSaveVC, animated: true)
                
            case .failure(let error):
//                self.view.makeToast(error.rawValue, duration: 5.0, position: .center)
                print("\(error)######")
        }
        }
        
    }
    
    
    // 셀의 크기 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let articleList = projectListInfo.articleList
                let articleInfo = articleList[indexPath[1]]
                let projectId = articleInfo.projectId
                MyAlamofireManager.shared.deleteProject(projectID: projectId) { result in
                    if result == .success(1) {
                        DispatchQueue.main.async {
                            projectListInfo.articleList.remove(at: indexPath.row)
                            tableView.reloadData()
                            tableView.setNeedsLayout()
                        }
                    } else {
                        
                        self.view.makeToast("본인의 글이 아닙니다.", duration: 1.0, position: .center)
                    }
                    
                }
            }
        }
}
