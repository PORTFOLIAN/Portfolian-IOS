//
//  MyPageViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/13.
//

import UIKit
import Then
import SnapKit
import SafariServices

class MyPageViewController: UIViewController {
    let identifier = "TagCollectionViewCell"
    let titleLabel = UILabel().then { UILabel in
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 20)
    }
    
    lazy var reportBarButtonItem = UIBarButtonItem(image: UIImage(named: "report"), style: .plain, target: self, action: #selector(buttonPressed(_:))).then { UIBarButtonItem in
        UIBarButtonItem.tintColor = ColorPortfolian.baseBlack
        UIBarButtonItem.image?.accessibilityPath?.lineWidth = 0.4
    }
    lazy var tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout()).then { UICollectionView in
        UICollectionView.isUserInteractionEnabled = false
    }
    lazy var introduceLabel = UILabel().then { UILabel in
        UILabel.textAlignment = .left
        UILabel.sizeToFit()
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 16)
    }
    
    lazy var profileImageView = UIImageView().then { UIImageView in
        lazy var image = UIImage(named: "profile")
        UIImageView.image = image
        UIImageView.layer.cornerRadius = 50
        UIImageView.layer.borderWidth = 1
        UIImageView.layer.borderColor = ColorPortfolian.baseBlack.cgColor
        UIImageView.clipsToBounds = true
    }
    
    lazy var setting = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(buttonPressed(_:))).then { UIBarButtonItem in
        UIBarButtonItem.tintColor = ColorPortfolian.baseBlack
    }
    
    lazy var userNameLabel = UILabel().then { UILabel in
        UILabel.text = "포트폴리안"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var gitHubButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "github"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var emailButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "email"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    lazy var cancelBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonPressed(_:))).then { UIBarButtonItem in
    }
    
    lazy var profileCorrectionButton = UIButton().then { UIButton in
        if profileType == .myProfile {
            UIButton.setTitle("프로필 수정", for: .normal)
        } else {
            UIButton.setTitle("", for: .normal)
        }
        UIButton.setTitleColor(ColorPortfolian.baseBlack, for: .normal)
        UIButton.layer.borderWidth = 1
        UIButton.layer.cornerRadius = 8
        UIButton.layer.borderColor = UIColor.gray.cgColor
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    var descriptionLineView = UIView().then { UIView in
        UIView.backgroundColor = .systemGray5
    }
    
    var emailString: String?
    var githubString: String?
    var userId: String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
        registrationType = .MyPage
        if profileType == .yourProfile {
            userId = chatRoom.user.userId
            navigationItem.title = "유저 프로필"
            navigationItem.leftBarButtonItem = cancelBarButtonItem
            navigationItem.rightBarButtonItem = reportBarButtonItem
        } else if profileType == .yourProjectProfile {
            userId = projectInfo.leader.userId
            navigationItem.title = "유저 프로필"
            navigationItem.leftBarButtonItem = cancelBarButtonItem
            navigationItem.rightBarButtonItem = reportBarButtonItem
        } else {
            userId = JwtToken.shared.userId
            titleLabel.text = "마이 프로필"
        }
        MyAlamofireManager.shared.getProfile(userId: userId) { response in
            switch response {
            case .success(let user):
                self.userNameLabel.text = user.nickName
                self.introduceLabel.text = user.description
                self.emailString = user.mail
                self.githubString = "https://github.com/" + user.github
                URLSession.shared.dataTask( with: NSURL(string:user.photo)! as URL, completionHandler: {
                    (data, response, error) -> Void in
                    DispatchQueue.main.async { [weak self] in
                        
                        if let data = data {
                            let image = UIImage(data: data)
                            self?.profileImageView.image = image
                        }
                    }
                }).resume()
                myTag = TagDataStore()
                
                DispatchQueue.main.async {
                    if user.stackList != [] {
                        for stack in user.stackList {
                            if Tag.Name(rawValue: stack) != nil {
                                myTag.names.append(Tag.Name(rawValue: stack)!)
                            }
                        }
                    }
                    self.tagCollectionView.reloadData()
                    let height = self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.tagCollectionView.snp.updateConstraints {
                        $0.height.equalTo(height)
                    }
                    self.view.setNeedsLayout()
                }

            case .failure(let error):
                print(error)
            }
        }
        if profileType != .myProfile {
            profileCorrectionButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if loginType == .no {
            self.shakeButton(button: self.profileCorrectionButton)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpItem()
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(gitHubButton)
        view.addSubview(emailButton)
        view.addSubview(emailButton)
        view.addSubview(profileCorrectionButton)
        view.addSubview(tagCollectionView)
        view.addSubview(introduceLabel)
        view.addSubview(descriptionLineView)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(100)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.top.equalTo(profileImageView).offset(10)
        }
        gitHubButton.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.bottom.equalTo(profileImageView).inset(10)
        }
        
        emailButton.snp.makeConstraints { make in
            make.leading.equalTo(gitHubButton.snp.trailing).offset(20)
            make.bottom.equalTo(profileImageView).inset(10)
        }
        profileCorrectionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileCorrectionButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(profileCorrectionButton)
            make.height.equalTo(0)
        }
        descriptionLineView.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(10)
            make.height.equalTo(1)
            make.leading.trailing.equalTo(tagCollectionView)
            
        }
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLineView.snp.bottom).offset(10)
            make.leading.equalTo(tagCollectionView)
            
        }
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        if loginType == .no {
            profileCorrectionButton.setTitle("로그인 하러가기", for: .normal)
            profileCorrectionButton.setTitleColor(ColorPortfolian.thema, for: .normal)
            profileCorrectionButton.layer.borderColor = ColorPortfolian.thema.cgColor
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case setting:
            if loginType == .no {
                view.makeToast("😅 로그인 후 이용해주세요.", duration: 0.75, position: .center)
            } else {
                let SettingVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "SettingVC")
                self.navigationController?.pushViewController(SettingVC, animated: true)
            }
            
        case profileCorrectionButton:
            if loginType == .no {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                  sceneDelegate.goToSignIn()
                }
            } else {
                let profileVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
                self.navigationController?.pushViewController(profileVC, animated: true)
            }

        case emailButton:
            if loginType != .no {
                if emailString != "" {
                    UIPasteboard.general.string = emailString
                    self.view.makeToast("이메일이 클립보드로 저장되었습니다.", duration: 1.0, position: .center)
                } else {
                    self.view.makeToast("유저가 이메일을 아직 등록하지 않았습니다.", duration: 1.0, position: .center)
                }
            } else {
                view.makeToast("😅 로그인 후 이용해주세요.", duration: 0.75, position: .center)
            }

        case gitHubButton:
            if loginType != .no {
                if let githubString = githubString {
                    if let url = URL(string: githubString) {
                        if githubString == "https://github.com/" {
                            self.view.makeToast("깃허브 주소를 아직 등록하지 않았습니다.", duration: 1.0, position: .center)
                        } else {
                            let safariViewController = WebViewController()
                            safariViewController.url = url
                            present(safariViewController, animated: true, completion: nil)
                        }
                    } else {
                        self.view.makeToast("깃허브 주소가 올바르지 않습니다.", duration: 1.0, position: .center)
                    }
                }
            } else {
                view.makeToast("😅 로그인 후 이용해주세요.", duration: 0.75, position: .center)
            }
        case cancelBarButtonItem:
            self.navigationController?.popViewController(animated: true)
        case reportBarButtonItem:
            self.reportAlert { [weak self] report in
                guard let self = self else { return }
                MyAlamofireManager.shared.reportUser(userId: self.userId, reason: report) { result in
                    self.view.makeToast("성공적으로 신고되었습니다.", duration: 0.75, position: .center)
                }
            }
        default:
            break
        }
        
    }
    func setUpItem() {
        navigationItem.rightBarButtonItem = setting
    }
    func shakeButton(button: UIButton) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            button.frame.origin.x -= 20
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                button.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    button.frame.origin.x -= 10
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        button.frame.origin.x += 10
                    })
                })
            })
        })
    }
    func reportAlert(completion: @escaping (String)->Void) {
        let alert = UIAlertController(title: "신고 사유 선택", message: nil, preferredStyle: .actionSheet)
        var reportString = ""
        let report1 = UIAlertAction(title: "욕설을 했어요", style: .default) { _ in
            reportString = "욕설을 했어요"
            completion(reportString)
        }
        let report2 = UIAlertAction(title: "성희롱을 했어요", style: .default) { _ in
            reportString = "성희롱을 했어요"
            completion(reportString)
        }
        let report3 = UIAlertAction(title: "다른 목적의 대화를 시도해요", style: .default) { _ in
            reportString = "다른 목적의 대화를 시도해요"
            completion(reportString)
        }
        let report4 = UIAlertAction(title: "부적절한 아이디에요", style: .default) { _ in
            reportString = "부적절한 아이디에요"
         
            completion(reportString)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(report1)
        alert.addAction(report2)
        alert.addAction(report3)
        alert.addAction(report4)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: false)
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(SPACINGROW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(SPACINGCOL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 더비 라벨을 만들어줘서 크기를 버튼의 크기를 예상하여 넣어준다.
        let tag = myTag.names[indexPath.row]
        let tagInfo = Tag.shared.getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let button = TagButton().then {
            $0.informTextInfo(text: tagName, fontSize: 16)
            $0.sizeToFit()
        }
        let size = button.frame.size
        return CGSize(width: size.width, height: size.height + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension MyPageViewController: UICollectionViewDataSource {
    // 한 섹션에 몇개의 컬렉션 셀을 보여줄지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myTag.names.count
    }
    
    // 셀을 어떻게 보여줄지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        let tag = myTag.names[indexPath.row]
        let tagInfo = Tag.shared.getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let tagColor = tagInfo.color
        cell.configure(tagName: tagName, tagColor: tagColor, index: tag.index)
        return cell
    }
}
