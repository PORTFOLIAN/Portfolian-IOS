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
        tableView.delegate = self
        tableView.dataSource = self
        subview()
        constraints()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MyAlamofireManager.shared.getBookmarkList { result in
            self.tableView.reloadData()
            self.tableView.setNeedsLayout()
        }
    }
    
    // Mark: SetupLogo
    func setUpLogo() {
        navigationItem.leftBarButtonItem = logo
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

extension BookmarkViewController: BookmarkButtonDelegate {
    func didTouchBookmarkButton(didClicked: Bool, sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint(x: 5, y: 5), to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        print(indexPath)
        var articleList = bookmarkListInfo.articleList
        let articleInfo = articleList[indexPath?[1] ?? 0]
        let projectId = articleInfo.projectId
        var bookMarked = articleInfo.bookMark
        bookMarked.toggle()
        let bookmark = Bookmark(projectId: projectId, bookMarked: bookMarked)
        MyAlamofireManager.shared.postBookmark(bookmark: bookmark) { result in
                MyAlamofireManager.shared.getBookmarkList { result in
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.setNeedsLayout()
                    }
                }
        }
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkListInfo.articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.cellDelegate = self
        
        let articleList = bookmarkListInfo.articleList
        let articleInfo = articleList[indexPath[1]]
        cell.titleLabel.text = articleInfo.title
        let lenStackList = articleInfo.stackList.count
        let stringTag = articleInfo.stackList
        var labelStackCount: Int = 0
        var tagInfo1, tagInfo2, tagInfo3: TagInfo
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
//        북마크 버튼을 눌렀을 때 값을 변경해주는 메소드를 구현하고 넣기
        
//        if articleInfo.bookMark == false {
//            cell.bookmarkButton.setImage(UIImage(named: "BookmarkFill"), for: .highlighted)
//        } else {
//            cell.bookmarkButton.setImage(UIImage(named: "Bookmark2"), for: .normal)
//        }
        cell.viewsLabel.text = "조회 \(articleInfo.view)"
        
        return cell
    }
    
    // 셀이 선택 되었을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
        var articleList = bookmarkListInfo.articleList
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
}
