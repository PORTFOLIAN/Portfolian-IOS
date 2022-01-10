//
//  ProfileViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/10.
//

import UIKit
import SnapKit
import Then
import PhotosUI
class ProfileViewController: UIViewController {
    lazy var profileButton = UIButton().then { UIButton in
        lazy var image = UIImage(named: "Profile")
        UIButton.setImage(image, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
        
    lazy var phpickerConfiguration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        return configuration
    }()
    
    lazy var phpicker = PHPickerViewController(configuration: phpickerConfiguration)
    
    let identifier = "TagCollectionViewCell"
    
    lazy var tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    
    lazy var lineViewFirst = UIView().then { UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    }
    
    lazy var lineViewSecond = UIView().then { UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    }
    
    lazy var nickNameLabel = UILabel().then { UILabel in
        UILabel.text = "닉네임"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    lazy var githubLabel = UILabel().then { UILabel in
        UILabel.text = "깃허브"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    lazy var emailLabel = UILabel().then { UILabel in
        UILabel.text = "이메일"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    lazy var introduceLabel = UILabel().then { UILabel in
        UILabel.text = "소개"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
    
    lazy var nicknameTextField = UITextField().then { UITextField in
        UITextField.placeholder = "최대 10글자"
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        
    }
    
    lazy var githubTextField = UITextField().then { UITextField in
        UITextField.placeholder = "https://github.com/yi-sang"
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        
    }
    
    lazy var emailTextField = UITextField().then { UITextField in
        UITextField.placeholder = "sanghyle@icloud.com"
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        
    }
    
    lazy var introduceTextView = UITextView().then { UITextView in
        UITextView.text = "최대 10글자"
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 16)
    }
    
    lazy var configuration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        let title = "사용 기술을 선택해주세요. (최대 7개)"
        let icon = UIImage(systemName: "chevron.right")
        configuration.title = title
        configuration.image = icon
        //        configuration.imagePadding = 30
        configuration.imagePlacement = .trailing
        configuration.baseForegroundColor = .black
        configuration.buttonSize = .medium
        configuration.baseBackgroundColor = .white
        return configuration
    }()
    
    lazy var stackButton = UIButton(configuration: configuration, primaryAction: nil).then { UIButton in
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        registrationType = .MyPage
        MyAlamofireManager.shared.getMyProfile { response in
            switch response {
            case .success(let user):
                if let url = URL(string: user.photo) {
                    print(url)
                    let data = try? Data(contentsOf: url)
                    self.profileButton.setImage(UIImage(data: data!), for: .normal)
                }
//                if user.stackList != [] {
//                    for stack in user.stackList {
//                        myTag.names.append(Tag.Name(rawValue: stack)!)
//                    }
//                }
//                myTag.names.append(Tag.Name(rawValue: "backEnd")!)
//                self.tagCollectionView.reloadData()

                
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
        
        view.addSubview(profileButton)
        view.addSubview(lineViewFirst)
        view.addSubview(lineViewSecond)
        view.addSubview(nickNameLabel)
        view.addSubview(githubLabel)
        view.addSubview(emailLabel)
        view.addSubview(introduceLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(githubTextField)
        view.addSubview(emailTextField)
        view.addSubview(introduceTextView)
        view.addSubview(stackButton)
        view.addSubview(tagCollectionView)
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view.center)

            make.width.height.equalTo(100)
            
        }
        lineViewFirst.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewFirst.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        githubLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(githubLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel)
            make.leading.equalTo(nickNameLabel.snp.trailing).offset(10)
        }
        githubTextField.snp.makeConstraints { make in
            make.centerY.equalTo(githubLabel)
            make.leading.equalTo(githubLabel.snp.trailing).offset(10)
        }
        emailTextField.snp.makeConstraints { make in
            make.centerY.equalTo(emailLabel)
            make.leading.equalTo(emailLabel.snp.trailing).offset(10)
        }
        
        introduceTextView.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(0.5)
            make.leading.equalTo(emailLabel.snp.trailing).offset(5)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(100)
            
        }
        lineViewSecond.snp.makeConstraints { make in
            make.top.equalTo(introduceTextView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        stackButton.snp.makeConstraints { make in
            make.top.equalTo(lineViewSecond.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(0)
        }
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        // Do
        // Do any additional setup after loading the view.

    }
    
    func alert(_ title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        //        let titleAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!, NSAttributedStringKey.foregroundColor: UIColor.black]
        let library = UIAlertAction(title: "사진 앨범", style: .default) { _ in
            self.openLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(library)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func openLibrary(){
//        imagePicker.sourceType = .PHPicker
        phpicker.delegate = self
        
        present(phpicker, animated: true, completion: nil)
        
    }

    
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case profileButton:
            alert("프로필 사진을 선택해주세요:)")
        case stackButton:
            registrationType = .MyPage
            
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            self.navigationController?.pushViewController(FilterVC, animated: true)
        default:
            break
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
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingColumn)
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
        //        TagCOllectionViewCell에서 contentView.isUserInteractionEnabled = true 해주면 함수 동작함. 대신 색이 안 나옴.
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
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
    
extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                let uiImage = image as? UIImage
                DispatchQueue.main.async {
                    self.profileButton.setImage(uiImage, for: .normal)
                    self.profileButton.layer.cornerRadius = 50
                    self.profileButton.layer.borderWidth = 1
                    self.profileButton.clipsToBounds = true
                }
            }
        } else {
            
        }
        dismiss(animated: true)
        
    }
    
}
