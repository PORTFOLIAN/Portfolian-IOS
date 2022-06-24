//
//  WritingViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/29.
//

import UIKit
import SnapKit
import Then
import CoreData
import SwiftyMarkdown
import KakaoSDKCommon

class WritingViewController: UIViewController {
    let periodInit = "예시: 3개월, 2021.09 ~ 2021.11"
    let explainInit = "프로젝트에 대한 간단한 설명을 적어주세요."
    let optionInit = "프로젝트에 필요한 기술 역량에 대해 알려주세요."
    let proceedInit = "예시: 매주 화요일 강남역에서 오프라인으로 진행합니다."
    let detailInit = "마크다운을 사용할 수 있어요!\n프로젝트에 대한 설명을 자유롭게 적어주세요 :)"
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    lazy var cancelBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
    lazy var saveBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(buttonPressed(_:)))
    // cellForItemAt은 콜렉션뷰의 크기가 0보다 커야 실행된다.
    lazy var tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    
    lazy var tagsCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    
    lazy var titleTextField = UITextField().then({ UITextField in
        UITextField.placeholder = "제목을 입력하세요."
        UITextField.font = UIFont(name: "NotoSansKR-Bold", size: 24)
    })
    
    lazy var stackButton : UIButton = {
        var button = UIButton()
        button.setTitle("본인의 사용 기술을 선택해주세요.", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(ColorPortfolian.baseBlack, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var chevronButton : UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right")?.withTintColor(ColorPortfolian.baseBlack, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var teamStackButton : UIButton = {
        var button = UIButton()
        button.setTitle("팀원들의 사용 기술을 선택해주세요.", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(ColorPortfolian.baseBlack, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var teamChevronButton : UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right")?.withTintColor(ColorPortfolian.baseBlack, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var leftUIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30)).then({ UIView in
        let icon = UIImage(named: "addUser")
        var iconView = UIImageView(image: icon)
        iconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        UIView.addSubview(iconView)
        UIView.contentMode = .bottom
    })
    
    lazy var recruitTextField = UITextField().then({ UITextField in
        UITextField.placeholder = "모집 인원"
        UITextField.leftView = leftUIView
        UITextField.leftViewMode = .always
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 18)
        UITextField.keyboardType = .numberPad
    })
    
    lazy var periodTextView = UITextView().then({ UITextView in
        UITextView.text = periodInit
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 2
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextView.layer.borderColor = ColorPortfolian.baseBlack.cgColor
        UITextView.layer.borderWidth = 0.4
        UITextView.layer.cornerRadius = 20
    })
    
    lazy var explainTextView = UITextView().then({ UITextView in
        UITextView.text = explainInit
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextView.layer.borderColor = ColorPortfolian.baseBlack.cgColor
        UITextView.layer.borderWidth = 0.4
        UITextView.layer.cornerRadius = 20
    })
    
    lazy var optionTextView = UITextView().then({ UITextView in
        UITextView.text = optionInit
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextView.layer.borderColor = ColorPortfolian.baseBlack.cgColor
        UITextView.layer.borderWidth = 0.4
        UITextView.layer.cornerRadius = 20
    })
    
    lazy var proceedTextView = UITextView().then({ UITextView in
        UITextView.text = proceedInit
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextView.layer.borderColor = ColorPortfolian.baseBlack.cgColor
        UITextView.layer.borderWidth = 0.4
        UITextView.layer.cornerRadius = 20
    })
    
    lazy var detailTextView = UITextView().then({ UITextView in
        UITextView.text = detailInit
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 0
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextView.layer.borderColor = ColorPortfolian.baseBlack.cgColor
        UITextView.layer.borderWidth = 0.3
        UITextView.layer.cornerRadius = 20
    })
    
    lazy var periodLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 기간"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var recruitLabel = UILabel().then { UILabel in
        UILabel.text = "명 (최대 16명)"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var explainLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 주제 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var optionLabel = UILabel().then { UILabel in
        UILabel.text = "모집 조건"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var proceedLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 진행 방식"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var detailLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 상세 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 18)
    }
    
    lazy var markdownButton = UIButton().then { UIButton in
        UIButton.setTitle("마크다운 사용법", for: .normal)
        UIButton.setTitleColor(ColorPortfolian.thema, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    var detailMarkdownTextView = UITextView().then ({ UITextView in
        UITextView.textColor = ColorPortfolian.baseBlack
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UITextView.isEditable = false
        UITextView.isUserInteractionEnabled = true
        UITextView.sizeToFit()
        UITextView.isScrollEnabled = true
        UITextView.layer.borderColor = ColorPortfolian.baseBlack.cgColor
        UITextView.layer.borderWidth = 0.3
        UITextView.layer.cornerRadius = 20
    })
    
    
    lazy var lineViewFirst = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.noclickTag
    })
    
    lazy var lineViewSecond = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.noclickTag
    })
    
    lazy var lineViewThird = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.noclickTag
    })
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        registrationType = .Writing
        if editType == .edit {
            MyAlamofireManager.shared.getProject(projectID: recruitWriting.newProjectID) { [weak self] in
                guard let self = self else { return }
                self.titleTextField.text = projectInfo.title
                self.titleTextField.textColor = ColorPortfolian.baseBlack
                
                self.recruitTextField.text = String(projectInfo.capacity)
                self.recruitTextField.textColor = ColorPortfolian.baseBlack
                
                self.explainTextView.text = projectInfo.contents.subjectDescription
                self.explainTextView.textColor = ColorPortfolian.baseBlack
                
                self.periodTextView.text = projectInfo.contents.projectTime
                self.periodTextView.textColor = ColorPortfolian.baseBlack
                
                self.optionTextView.text = projectInfo.contents.recruitmentCondition
                self.optionTextView.textColor = ColorPortfolian.baseBlack
                
                self.proceedTextView.text = projectInfo.contents.progress
                self.proceedTextView.textColor = ColorPortfolian.baseBlack
                
                self.detailTextView.text = projectInfo.contents.description
                self.detailTextView.textColor = ColorPortfolian.baseBlack
                
                self.configureLabel(fromTextView: self.detailTextView, toTextView: self.detailMarkdownTextView)
            }
        } else if isMovingToParent == true {
            fetchWriting()
            
            configureLabel(fromTextView: detailTextView, toTextView: detailMarkdownTextView)
        }
        
        DispatchQueue.main.async {
            self.tagCollectionView.reloadData()
            self.tagsCollectionView.reloadData()
            
            var height = self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.tagCollectionView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
            
            height = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.tagsCollectionView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "글쓰기"
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(tagCollectionView)
        contentView.addSubview(tagsCollectionView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(lineViewFirst)
        contentView.addSubview(lineViewSecond)
        contentView.addSubview(lineViewThird)
        contentView.addSubview(stackButton)
        contentView.addSubview(chevronButton)
        contentView.addSubview(teamStackButton)
        contentView.addSubview(teamChevronButton)
        contentView.addSubview(recruitTextField)
        contentView.addSubview(recruitLabel)
        contentView.addSubview(periodLabel)
        contentView.addSubview(explainLabel)
        contentView.addSubview(optionLabel)
        contentView.addSubview(proceedLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(periodTextView)
        contentView.addSubview(explainTextView)
        contentView.addSubview(optionTextView)
        contentView.addSubview(proceedTextView)
        contentView.addSubview(detailTextView)
        contentView.addSubview(detailMarkdownTextView)
        contentView.addSubview(markdownButton)
        
        titleTextField.delegate = self
        periodTextView.delegate = self
        explainTextView.delegate = self
        optionTextView.delegate = self
        proceedTextView.delegate = self
        detailTextView.delegate = self
        
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: IDENTIFIER)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        tagsCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: IDENTIFIER)
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).inset(20)
            make.width.equalTo(scrollView).offset(-40)
            make.bottom.equalTo(detailTextView).offset(350)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5)
            make.leading.trailing.equalTo(contentView).inset(10)
        }
        
        lineViewFirst.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        stackButton.snp.makeConstraints { make in
            make.top.equalTo(lineViewFirst).offset(10)
            make.leading.equalTo(lineViewFirst)
            make.trailing.equalTo(lineViewFirst).offset(-20)
        }
        
        chevronButton.snp.makeConstraints { make in
            make.centerY.equalTo(stackButton)
            make.trailing.equalTo(lineViewFirst)
            make.height.width.equalTo(20)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(lineViewFirst)
            make.height.equalTo(0)
        }
        
        teamStackButton.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(lineViewFirst)
            make.trailing.equalTo(lineViewFirst).offset(-20)
        }
        
        teamChevronButton.snp.makeConstraints { make in
            make.centerY.equalTo(teamStackButton)
            make.trailing.equalTo(lineViewFirst)
            make.height.width.equalTo(20)
            
        }
        
        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(teamStackButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(lineViewFirst)
            make.height.equalTo(0)
        }
        
        lineViewSecond.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        recruitTextField.snp.makeConstraints { make in
            make.top.equalTo(lineViewSecond).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitTextField)
            make.leading.equalTo(recruitTextField.snp.trailing).offset(10)
        }
        
        lineViewThird.snp.makeConstraints { make in
            make.top.equalTo(recruitTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewThird).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        periodTextView.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(periodTextView.snp.bottom).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        explainTextView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(explainTextView.snp.bottom).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        optionTextView.snp.makeConstraints { make in
            make.top.equalTo(optionLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        proceedLabel.snp.makeConstraints { make in
            make.top.equalTo(optionTextView.snp.bottom).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        proceedTextView.snp.makeConstraints { make in
            make.top.equalTo(proceedLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(proceedTextView.snp.bottom).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        markdownButton.snp.makeConstraints { make in
            make.top.equalTo(detailLabel)
            make.trailing.equalTo(detailTextView)
        }
        
        detailMarkdownTextView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(150)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailMarkdownTextView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(300)
        }
    }
    
    func alert(_ title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        //        let titleAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!, NSAttributedStringKey.foregroundColor: UIColorColorPortfolian.baseBlack]
        let saveAction = UIAlertAction(title: "저장하기", style: .default) { _ in
            self.saveWriting()
            self.navigationController?.popViewController(animated: true)
            
        }
        
        let refuseAction = UIAlertAction(title: "저장하지않고 나가기", style: .destructive) { _ in
            self.deleteWriting()
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addAction(refuseAction)
        self.present(alert, animated: false)
    }
    
    func saveWriting() {
        let numRecruit = Int(recruitTextField.text!)
        var stringTags: [String] = []
        for tag in writingOwnerTag.names {
            stringTags.append(tag.rawValue)
        }
        
        var stringTeamTags: [String] = []
        for tag in writingTeamTag.names {
            stringTeamTags.append(tag.rawValue)
        }
        
        let myWriting = Person(title: titleTextField.text, tags: stringTags, teamTags: stringTeamTags, recruit: numRecruit, period: periodTextView.text, explain: explainTextView.text, option: optionTextView.text, proceed: proceedTextView.text, detail: detailTextView.text)
        PersistenceManager.shared.insertPerson(person: myWriting)
    }
    
    func fetchWriting() {
        print("fetchWriting - start")
        
        let request: NSFetchRequest<Writing> = Writing.fetchRequest()
        let fetchResult = PersistenceManager.shared.fetch(request: request)
        fetchResult.forEach {
            if $0.title != nil {
                titleTextField.text = $0.title
            }
            if $0.tags != nil {
                writingOwnerTag.names = []
                for tag in $0.tags! {
                    writingOwnerTag.names.append(Tag.Name(rawValue: tag)!)
                }
            } else {
                writingOwnerTag.names = []
            }
            print("writingTag: \(writingOwnerTag.names)")
            
            if $0.teamTags != nil {
                writingTeamTag.names = []
                for tag in $0.teamTags! {
                    writingTeamTag.names.append(Tag.Name(rawValue: tag)!)
                }
            } else {
                writingTeamTag.names = []
            }
            print("writingTeamTag: \(writingTeamTag.names)")
            recruitTextField.text = String($0.recruit)
            
            
            if $0.period != periodInit {
                periodTextView.text = $0.period
                periodTextView.textColor = ColorPortfolian.baseBlack
            } else {
                periodTextView.text = periodInit
                periodTextView.textColor = ColorPortfolian.gray2
            }
            
            if $0.explain != explainInit {
                explainTextView.text = $0.explain
                explainTextView.textColor = ColorPortfolian.baseBlack
            } else {
                explainTextView.text = explainInit
                explainTextView.textColor = ColorPortfolian.gray2
            }
            
            if $0.option != optionInit {
                optionTextView.text = $0.option
                optionTextView.textColor = ColorPortfolian.baseBlack
            } else {
                optionTextView.text = optionInit
                optionTextView.textColor = ColorPortfolian.gray2
            }
            
            if $0.proceed != proceedInit {
                proceedTextView.text = $0.proceed
                proceedTextView.textColor = ColorPortfolian.baseBlack
            } else {
                proceedTextView.text = proceedInit
                proceedTextView.textColor = ColorPortfolian.gray2
            }
            
            if $0.detail != detailInit {
                detailTextView.text = $0.detail
                detailTextView.textColor = ColorPortfolian.baseBlack
            } else {
                detailTextView.text = detailInit
                
                detailTextView.textColor = ColorPortfolian.gray2
            }
        }
    }
    
    func deleteWriting() {
        let request: NSFetchRequest<Writing> = Writing.fetchRequest()
        PersistenceManager.shared.deleteAll(request: request)
        let arr = PersistenceManager.shared.fetch(request: request)
        if arr.isEmpty {
            print("clean")
        }
        writingTeamTag.names = []
        writingOwnerTag.names = []
    }
    
    // MARK: - Navigation
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case saveBarButtonItem:
            //            guard let userInput = searchBar.text else { return }
            let numRecruit = Int(recruitTextField.text!)
            var stringTags: [String] = []
            for tag in writingTeamTag.names {
                stringTags.append(tag.rawValue)
            }
            
            let projectArticle = ProjectArticle(title: titleTextField.text, stackList: stringTags, subjectDescription: explainTextView.text, projectTime: periodTextView.text, condition: optionTextView.text, progress: proceedTextView.text, description: detailTextView.text, capacity: numRecruit)
            if editType == .yet {
                MyAlamofireManager.shared.getProjectID(projectTerm: projectArticle) { [weak self] in
                    guard let self = self else { return }
                    
                        MyAlamofireManager.shared.getProject(projectID: recruitWriting.newProjectID) { [weak self] in
                            guard let self = self else { return }
                            self.deleteWriting()
                            for tag in projectInfo.stackList{
                                guard let tagName = Tag.Name(rawValue: tag) else { return }
                                writingTeamTag.names.append(tagName)
                            }
                            guard let tagName = Tag.Name(rawValue: projectInfo.leader.stack) else { return }
                            writingOwnerTag.names.append(tagName)
                            
                            let WritingSaveVC = UIStoryboard(name: "WritingSave", bundle: nil).instantiateViewController(withIdentifier: "WritingSaveVC")
                            self.navigationController?.popToRootViewController(animated: true)
                            self.navigationController?.viewControllers.first?.navigationController?.pushViewController(WritingSaveVC, animated: true)
                        }
                }
            } else {
                MyAlamofireManager.shared.putProject(projectArticle: projectArticle) {
                    MyAlamofireManager.shared.getProject(projectID: recruitWriting.newProjectID) { [weak self] in
                        guard let self = self else { return }
                        writingOwnerTag.names = []
                        writingTeamTag.names = []
                        
                        for tag in projectInfo.stackList{
                            guard let tagName = Tag.Name(rawValue: tag) else { return }
                            writingTeamTag.names.append(tagName)
                        }
                        guard let tagName = Tag.Name(rawValue: projectInfo.leader.stack) else { return }
                        writingOwnerTag.names.append(tagName)
                        
                        let WritingSaveVC = UIStoryboard(name: "WritingSave", bundle: nil).instantiateViewController(withIdentifier: "WritingSaveVC")
                        self.navigationController?.popToRootViewController(animated: true)
                        self.navigationController?.viewControllers.first?.navigationController?.pushViewController(WritingSaveVC, animated: true)
                    }
                }
            }
        case cancelBarButtonItem:
            if editType == .yet {
                self.alert("임시 저장하시겠습니까?")
            } else {
                MyAlamofireManager.shared.getProject(projectID: recruitWriting.newProjectID) { [weak self] in
                    guard let self = self else { return }
                    print("WritingViewController \(writingTeamTag.names)")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        case stackButton, chevronButton:
            registrationType = .WritingOwner
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            self.navigationController?.pushViewController(FilterVC, animated: true)
        case teamStackButton, teamChevronButton:
            registrationType = .WritingTeam
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            self.navigationController?.pushViewController(FilterVC, animated: true)
        case markdownButton:
            let markdownVC = UIStoryboard(name: "Markdown", bundle: nil).instantiateViewController(withIdentifier: "MarkdownVC")
            present(markdownVC, animated: true)
        default:
            print("error?")
        }
        
    }
    
    fileprivate func configureLabel(fromTextView: UITextView, toTextView: UITextView) {
        let md = SwiftyMarkdown(string: fromTextView.text)
        toTextView.attributedText = md.attributedString()
        guard let messageText = toTextView.text else { return }
        let mutableString = NSMutableAttributedString()
        
        var urlAttributes: [NSMutableAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.italicSystemFont(ofSize: 16)
        ]
        
        // swiftyMarkdown
        let normalText = md.attributedString()
        mutableString.append(normalText)
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(
                in: messageText,
                options: [],
                range: NSRange(location: 0, length: messageText.count)
            )
            
            for m in matches {
                if let url = m.url {
                    urlAttributes[.link] = url
                    mutableString.setAttributes(urlAttributes, range: m.range)
                }
            }
            toTextView.attributedText = mutableString
        } catch {
            print(error)
        }
    }
}

extension WritingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == detailTextView {
            configureLabel(fromTextView: detailTextView, toTextView: detailMarkdownTextView)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ColorPortfolian.gray2{
            textView.text = ""
            textView.textColor = ColorPortfolian.baseBlack
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            switch textView {
            case periodTextView:
                textView.text = periodInit
            case explainTextView:
                textView.text = explainInit
            case optionTextView:
                textView.text = optionInit
            case proceedTextView:
                textView.text = proceedInit
            case detailTextView:
                textView.text = detailInit
                
                self.configureLabel(fromTextView: detailTextView, toTextView: detailMarkdownTextView)
            default:
                break
            }
            textView.textColor = ColorPortfolian.gray2
        }
    }
}

extension WritingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(SPACINGROW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(SPACINGCOL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 더비 라벨을 만들어줘서 크기를 버튼의 크기를 예상하여 넣어준다.
        switch collectionView {
        case tagCollectionView:
            let tag = writingOwnerTag.names[indexPath.row]
            let tagInfo = Tag.shared.getTagInfo(tag: tag)
            let tagName = tagInfo.name
            let label = TagButton().then {
                $0.informTextInfo(text: tagName, fontSize: 16)
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width, height: size.height + 10)
        default:
            let tag = writingTeamTag.names[indexPath.row]
            let tagInfo = Tag.shared.getTagInfo(tag: tag)
            let tagName = tagInfo.name
            let label = TagButton().then {
                $0.informTextInfo(text: tagName, fontSize: 16)
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width, height: size.height + 10)
        }
    }
}

extension WritingViewController: UICollectionViewDataSource {
    // 한 섹션에 몇개의 컬렉션 셀을 보여줄지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return writingOwnerTag.names.count
        } else {
            return writingTeamTag.names.count
        }
    }
    
    // 셀을 어떻게 보여줄지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case tagCollectionView:
            let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIER, for: indexPath) as! TagCollectionViewCell
            let tag = writingOwnerTag.names[indexPath.row]
            let tagInfo = Tag.shared.getTagInfo(tag: tag)
            let tagName = tagInfo.name
            let tagColor = tagInfo.color
            cell.configure(tagName: tagName, tagColor: tagColor, index: tag.index)
            return cell
        default:
            let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIER, for: indexPath) as! TagCollectionViewCell
            let tag = writingTeamTag.names[indexPath.row]
            let tagInfo = Tag.shared.getTagInfo(tag: tag)
            let tagName = tagInfo.name
            let tagColor = tagInfo.color
            cell.configure(tagName: tagName, tagColor: tagColor, index: tag.index)
            return cell
        }
    }
}

extension WritingViewController: UITextFieldDelegate {
    //MARK: - Limit 10 letters
    private func limitLetters(_ textField: UITextField, text: String) {
        let titleCharacterLimit = 32
        let endIndex: String.Index = text.index(text.startIndex, offsetBy: titleCharacterLimit)
        textField.text = String(text[..<endIndex])
        
    }
    
    internal func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let titleText = textField.text else { return }
        if titleText.count >= 32 {
            limitLetters(textField, text: titleText)
        }
    }
}
