//
//  MyPageViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/13.
//

import UIKit
import Then
import SnapKit
class MyPageViewController: UIViewController {
    let identifier = "TagCollectionViewCell"

    lazy var tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout()).then { UICollectionView in
        UICollectionView.isUserInteractionEnabled = false
    }
    lazy var introduceLabel = UILabel().then { UILabel in
        UILabel.text = "최대 10글자"
        UILabel.textColor = ColorPortfolian.gray2
        UILabel.textAlignment = .left
        UILabel.sizeToFit()
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 16)
    }
    

    
    lazy var profileImage = UIImageView().then { UIImageView in
        lazy var image = UIImage(named: "Profile")
        UIImageView.image = image
        UIImageView.layer.cornerRadius = 50
        UIImageView.layer.borderWidth = 1
        UIImageView.layer.borderColor = UIColor.clear.cgColor
        UIImageView.clipsToBounds = true

    }
    
    let settingImage = UIImage(named: "Setting")
    lazy var setting = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(buttonPressed(_:)))
    let pushImage = UIImage(named: "Push")
    
    lazy var push = UIBarButtonItem(image: pushImage, style: .plain, target: self, action: #selector(buttonPressed(_:)))
    lazy var userNameLabel = UILabel().then { UILabel in
        UILabel.text = "댕댕아 사랑해"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var gitHubButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "Github"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var emailButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(named: "Email"), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var profileCorrectionButton = UIButton().then { UIButton in
        UIButton.setTitle("프로필 수정", for: .normal)
        UIButton.setTitleColor(.black, for: .normal)
        UIButton.layer.borderWidth = 1
        UIButton.layer.cornerRadius = 8
        UIButton.layer.borderColor = UIColor.gray.cgColor
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "마이페이지"
        navigationController?.navigationBar.prefersLargeTitles = false
        registrationType = .MyPage
        MyAlamofireManager.shared.getMyProfile { response in
            switch response {
            case .success(let user):
                self.userNameLabel.text = user.nickName
                self.introduceLabel.text = user.description
                if let url = URL(string: user.photo) {
                    print(url)
                    let data = try? Data(contentsOf: url)
                    self.profileImage.image = UIImage(data: data!)
                }
                if user.stackList != [] {
                    for stack in user.stackList {
                        myTag.names.append(Tag.Name(rawValue: stack)!)
                    }
                }
                self.tagCollectionView.reloadData()

                
                print(myTag)
            case .failure(let error):
                print(error)
            default:
                break
            }
        }
        DispatchQueue.main.async {
            self.tagCollectionView.reloadData()

            let height = self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.tagCollectionView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        }
        self.view.setNeedsLayout()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpItem()
        view.addSubview(profileImage)
        view.addSubview(userNameLabel)
        view.addSubview(gitHubButton)
        view.addSubview(emailButton)
        view.addSubview(emailButton)
        view.addSubview(profileCorrectionButton)
        view.addSubview(tagCollectionView)
        view.addSubview(introduceLabel)
        profileImage.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(100)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.top.equalTo(profileImage).offset(10)
        }
        gitHubButton.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.bottom.equalTo(profileImage).inset(10)
        }
        
        emailButton.snp.makeConstraints { make in
            make.leading.equalTo(gitHubButton.snp.trailing).offset(20)
            make.bottom.equalTo(profileImage).inset(10)
        }
        profileCorrectionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(profileImage.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileCorrectionButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(profileCorrectionButton)
            make.height.equalTo(0)
        }
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(tagCollectionView).offset(20)
            
        }
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
    }
    
    // Mark: SetupLogo
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case setting:
            let SettingVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "SettingVC")
            self.navigationController?.pushViewController(SettingVC, animated: true)
        case push:
            print("push")
        case profileCorrectionButton:
            let profileVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
            print(profileVC)
            self.navigationController?.pushViewController(profileVC, animated: true)
        default:
            break
        }
        
    }
    func setUpItem() {
        navigationItem.rightBarButtonItems = [setting, push]
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
