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
class HomeViewController: UIViewController, UISearchBarDelegate {
    lazy var cache: NSCache<AnyObject, UIImage> = NSCache()
    
    lazy var logo: UIBarButtonItem = {
        let image = UIImage(named: "logo")?.resizeImage(size: CGSize(width: 150, height: 30)).withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 1
        return button
    }()
    
    lazy var search: UIBarButtonItem = {
        let image = UIImage(named: "search")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tag = 2
        button.tintColor = .black
        return button
    }()
    
    lazy var viewsCheckBox = UIButton().then({ UIButton in
        UIButton.setImage(UIImage(named: "checkbox"), for: .normal)
        UIButton.setImage(UIImage(named: "checkboxFill"), for: .selected)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    })
    
    lazy var viewsLabel = UILabel().then { UILabel in
        UILabel.text = "조회 순"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    lazy var latestCheckBox = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "checkboxFill"), for: .normal)
        UIButton.setImage(UIImage(named: "checkbox"), for: .selected)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var latestLabel = UILabel().then { UILabel in
        UILabel.text = "최신 순"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var filter: UIBarButtonItem = {
        let image = UIImage(named: "filter")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonPressed(_:)))
        button.tintColor = .black
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
        button.setImage(UIImage(named: "write")?.resizeImage(size: CGSize(width: 80, height: 80)), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let refreshControl = UIRefreshControl()
    var projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
    var searchKeyword = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpItem()
        setUpLogo()
        cache = NSCache()
        editType = .yet
        if searchingTag.names.first?.rawValue != nil {
            filter.tintColor = ColorPortfolian.thema
        } else {
            filter.tintColor = .black
        }
        if !self.latestCheckBox.isSelected {
            if let stack = searchingTag.names.first?.rawValue {
                projectSearch = ProjectSearch(stack: stack, sort: "default", keyword: "default")
            } else {
                projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
            }
        } else {
            if let stack = searchingTag.names.first?.rawValue {
                projectSearch = ProjectSearch(stack: stack, sort: "view", keyword: "default")
            } else {
                projectSearch = ProjectSearch(stack: "default", sort: "view", keyword: "default")
            }
        }
        searchProject(searchOption:projectSearch)
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
        //        self.tableView.separatorStyle = .none
        
    }
    
    // Mark: SetupLogo
    func setUpLogo() {
        navigationItem.leftBarButtonItem = logo
    }
    
    func setUpItem() {
        navigationItem.rightBarButtonItems = [filter, search]
    }
    
    //MARK: - ButtonPressed
    @objc private func barButtonPressed(_ sender: UIBarButtonItem) {
        switch sender {
        case search: // search
            disappearBarButton()
            configureSearchController()
            viewsCheckBox.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            latestCheckBox.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            viewsLabel.text = ""
            latestLabel.text = ""
            projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
            searchProject(searchOption:projectSearch)
        case filter: // filter
            registrationType = .Searching
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            self.navigationController?.pushViewController(FilterVC, animated: true)
            
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
            viewsCheckBox.isSelected = true
            latestCheckBox.isSelected = true
            if let stack = searchingTag.names.first?.rawValue {
                projectSearch = ProjectSearch(stack: stack, sort: "view", keyword: "default")
            } else {
                projectSearch = ProjectSearch(stack: "default", sort: "view", keyword: "default")
            }
            searchProject(searchOption:projectSearch)
            
        case latestCheckBox:
            viewsCheckBox.isSelected = false
            latestCheckBox.isSelected = false
            if let stack = searchingTag.names.first?.rawValue {
                projectSearch = ProjectSearch(stack: stack, sort: "default", keyword: "default")
            } else {
                projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
            }
            searchProject(searchOption:projectSearch)
        case refreshControl:
            print("새로고침 시작")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.cache = NSCache()
            }
            
        default:
            break
        }
        
    }
    
    //MARK: - Search bar
    func configureSearchController(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        navigationItem.searchController = searchController
        navigationItem.titleView = searchController.searchBar
        searchController.isActive = true
        searchController.searchBar.placeholder = "원하시는 프로젝트를 검색해보세요:)"
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
        viewsCheckBox.snp.updateConstraints { make in
            make.height.equalTo(15)
        }
        latestCheckBox.snp.updateConstraints { make in
            make.height.equalTo(15)
        }
        viewsLabel.text = "조회 순"
        latestLabel.text = "최신 순"
        
        if !self.latestCheckBox.isSelected {
            if let stack = searchingTag.names.first?.rawValue {
                projectSearch = ProjectSearch(stack: stack, sort: "default", keyword: "default")
            } else {
                projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
            }
        } else {
            if let stack = searchingTag.names.first?.rawValue {
                projectSearch = ProjectSearch(stack: stack, sort: "view", keyword: "default")
            } else {
                projectSearch = ProjectSearch(stack: "default", sort: "view", keyword: "default")
            }
        }
        searchProject(searchOption: projectSearch)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchKeyword = searchText
            projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: searchKeyword)
        } else {
            projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
        }
        searchProject(searchOption: projectSearch)
    }
    
    private func searchProject(searchOption: ProjectSearch) {
        MyAlamofireManager.shared.getProjectList(searchOption: projectSearch) { result in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.setNeedsLayout()
                
            }
        }
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
        let buttonPosition: CGPoint = sender.convert(CGPoint(x: 5, y: 5), to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let articleList = projectListInfo.articleList
        let articleInfo = articleList[indexPath?[1] ?? 0]
        let projectId = articleInfo.projectId
        var bookMarked = articleInfo.bookMark
        bookMarked.toggle()
        let bookmark = Bookmark(projectId: projectId, bookMarked: bookMarked)
        if latestLabel.text == "최신 순" {
            MyAlamofireManager.shared.postBookmark(bookmark: bookmark) { [weak self] result in
                guard let self = self else { return }
                if !self.latestCheckBox.isSelected {
                    if let stack = searchingTag.names.first?.rawValue {
                        self.projectSearch = ProjectSearch(stack: stack, sort: "default", keyword: "default")
                    } else {
                        self.projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
                    }
                } else {
                    if let stack = searchingTag.names.first?.rawValue {
                        self.projectSearch = ProjectSearch(stack: stack, sort: "view", keyword: "default")
                    } else {
                        self.projectSearch = ProjectSearch(stack: "default", sort: "view", keyword: "default")
                    }
                }
                self.searchProject(searchOption: self.projectSearch)
            }
        } else {
            MyAlamofireManager.shared.postBookmark(bookmark: bookmark) { [weak self] result in
                guard let self = self else { return }
                if self.searchKeyword == "" {
                    self.projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: "default")
                } else {
                    self.projectSearch = ProjectSearch(stack: "default", sort: "default", keyword: self.searchKeyword)
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
        print(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.cellDelegate = self
        let articleList = projectListInfo.articleList
        let articleInfo = articleList[indexPath[1]]
        cell.titleLabel.text = articleInfo.title
        let lenStackList = articleInfo.stackList.count
        let stringTag = articleInfo.stackList
        let bookmark = articleInfo.bookMark
        
        if cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil {
            cell.profileImageView.image = cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject)
        } else {
            let task = URLSession.shared.dataTask( with: NSURL(string:articleInfo.leader.photo)! as URL, completionHandler: {
                (data, response, error) -> Void in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    guard let cellIndex = tableView.indexPath(for: cell),
                          cellIndex == indexPath else { return }
                    cell.profileImageView.contentMode = .scaleToFill
                    if let data = data {
                        let image = UIImage(data: data)
                        cell.profileImageView.image = image
                        self.cache.setObject(image!, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    }
                }
            })
            task.resume()
        }
        if bookmark == true {
            cell.bookmarkButton.setImage(UIImage(named: "bookmarkFill")?.withTintColor(ColorPortfolian.thema, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            cell.bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
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
        self.navigationItem.searchController = nil
        self.navigationItem.titleView = nil
        
        let articleList = projectListInfo.articleList
        let articleInfo = articleList[indexPath[1]]
        let projectId = articleInfo.projectId
        recruitWriting.newProjectID = projectId
        MyAlamofireManager.shared.getProject(projectID: projectId) { result in
            switch result {
            case .success:
                writingTeamTag.names = []
                writingOwnerTag.names = []
                for tag in projectInfo.stackList {
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
            MyAlamofireManager.shared.deleteProject(projectID: projectId) { [weak self] result in
                if result == .success(1) {
                    self?.cache = NSCache()
                    DispatchQueue.main.async {
                        projectListInfo.articleList.remove(at: indexPath.row)
                        tableView.reloadData()
                        tableView.setNeedsLayout()
                    }
                } else {
                    self?.view.makeToast("본인의 글이 아닙니다.", duration: 1.0, position: .center)
                }
                
            }
        }
    }
}
