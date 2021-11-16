//
//  WritingViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/29.
//

import UIKit
import SnapKit
import Then


class WritingViewController: UIViewController {
    let identifier = "TagCollectionViewCell"
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    lazy var saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(buttonPressed))
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    lazy var titleTextField = UITextField().then({ UITextField in
        UITextField.placeholder = "제목을 입력하세요."
        UITextField.font = UIFont(name: "NotoSansKR-Bold", size: 24)
    })
    
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
    
    lazy var leftUIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30)).then({ UIView in
        let icon = UIImage(named: "AddUser")
        var iconView = UIImageView(image: icon)
        iconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        UIView.addSubview(iconView)
        UIView.contentMode = .bottom
    })
    
    lazy var recruitTextField = UITextField().then({ UITextField in
        UITextField.placeholder = "모집 인원"
        UITextField.leftView = leftUIView
        UITextField.leftViewMode = .always
        UITextField.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    })
    
    lazy var periodTextView = UITextView().then({ UITextView in
        UITextView.text = "예시: 3개월, 2021.09 ~ 2021.11"
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 2
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var explainTextView = UITextView().then({ UITextView in
        UITextView.text = "프로젝트에 대한 간단한 설명을 적어주세요."
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var optionTextView = UITextView().then({ UITextView in
        UITextView.text = "프로젝트에 필요한 기술 역량에 대해 알려주세요"
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var proceedTextView = UITextView().then({ UITextView in
        UITextView.text = "예시: 매주 화요일 강남역에서 오프라인으로 진행합니다."
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var detailTextView = UITextView().then({ UITextView in
        UITextView.text = "프로젝트에 대한 설명을 자유롭게 적어주세요 :)"
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 15
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var periodLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 기간"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var recruitLabel = UILabel().then { UILabel in
        UILabel.text = "명 (최대 16명)"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var explainLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 주제 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var optionLabel = UILabel().then { UILabel in
        UILabel.text = "모집 조건"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var proceedLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 진행 방식"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var detailLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 상세 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var lineViewFirst = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewSecond = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewThird = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewFourth = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewFifth = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewSixth = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewSeventh = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewEight = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        tagCollectionView.reloadData()
        let height = tagCollectionView.collectionViewLayout.collectionViewContentSize.height
        tagCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        view.setNeedsLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "글쓰기"
        navigationItem.rightBarButtonItem = saveBarButtonItem
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(tagCollectionView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(lineViewFirst)
        contentView.addSubview(lineViewSecond)
        contentView.addSubview(lineViewThird)
        contentView.addSubview(lineViewFourth)
        contentView.addSubview(lineViewFifth)
        contentView.addSubview(lineViewSixth)
        contentView.addSubview(lineViewSeventh)
        contentView.addSubview(lineViewEight)
        contentView.addSubview(stackButton)
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
        //        scrollView.backgroundColor = .blue
        //        contentView.backgroundColor = .yellow
        
        periodTextView.delegate = self
        explainTextView.delegate = self
        optionTextView.delegate = self
        proceedTextView.delegate = self
        detailTextView.delegate = self
        
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).inset(20)
            make.width.equalTo(scrollView).offset(-40)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5)
            make.leading.equalTo(contentView).offset(10)
        }
        
        lineViewFirst.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        stackButton.snp.makeConstraints { make in
            make.top.equalTo(lineViewFirst).offset(10)
            make.leading.equalTo(lineViewFirst)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(lineViewFirst)
            make.height.equalTo(0)
        }
        
        lineViewSecond.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(10)
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
        
        lineViewFourth.snp.makeConstraints { make in
            make.top.equalTo(periodTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewFourth).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        explainTextView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        lineViewFifth.snp.makeConstraints { make in
            make.top.equalTo(explainTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewFifth).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        optionTextView.snp.makeConstraints { make in
            make.top.equalTo(optionLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        lineViewSixth.snp.makeConstraints { make in
            make.top.equalTo(optionTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        proceedLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewSixth).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        proceedTextView.snp.makeConstraints { make in
            make.top.equalTo(proceedLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        lineViewSeventh.snp.makeConstraints { make in
            make.top.equalTo(proceedTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewSeventh).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(300)
        }
        
        lineViewEight.snp.makeConstraints { make in
            make.top.equalTo(detailTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
            make.bottom.equalTo(contentView.snp.bottom).inset(300)
            
        }
        
    }
    
    // MARK: - Navigation
    @objc private func buttonPressed(_ sender: UIButton) {
        let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
        FilterVC.modalPresentationStyle = .fullScreen
        registrationType = .Writing
        self.navigationController?.pushViewController(FilterVC, animated: true)
    }
}

extension WritingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ColorPortfolian.gray2{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            switch textView {
            case periodTextView:
                textView.text = "예시: 3개월, 2021.09 ~ 2021.11"
            case explainTextView:
                textView.text = "프로젝트에 대한 간단한 설명을 적어주세요."
            case optionTextView:
                textView.text = "프로젝트에 필요한 기술 역량에 대해 알려주세요"
            case proceedTextView:
                textView.text = "예시: 매주 화요일 강남역에서 오프라인으로 진행합니다."
            default:
                textView.text = "프로젝트에 대한 설명을 자유롭게 적어주세요 :)"
            }
            textView.textColor = ColorPortfolian.gray2
        }
    }
    
}

extension WritingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingColumn)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 더비 라벨을 만들어줘서 크기를 버튼의 크기를 예상하여 넣어준다.
        let tag = writingTag.names[indexPath.row]
        let tagInfo = getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let label = TagButton().then {
            $0.informTextInfo(text: tagName, fontSize: 16)
            $0.sizeToFit()
        }
        let size = label.frame.size
        return CGSize(width: size.width, height: size.height + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        //        TagCOllectionViewCell에서 contentView.isUserInteractionEnabled = true 해주면 함수 동작함. 대신 색이 안 나옴.
    }
}

extension WritingViewController: UICollectionViewDataSource {
    // 한 섹션에 몇개의 컬렉션 셀을 보여줄지
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return writingTag.names.count
    }
    // 셀을 어떻게 보여줄지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        let tag = writingTag.names[indexPath.row]
        let tagInfo = getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let tagColor = tagInfo.color
        cell.configure(tagName: tagName, tagColor: tagColor, index: tag.index)
        return cell
    }
    
    func getTagInfo(tag: Tag.Name?) -> TagInfo {
        switch tag {
        case .frontEnd  : return TagInfo(name: "Front-end", color: ColorPortfolian.frontEnd)
        case .backEnd   : return TagInfo(name: "Back-end", color: ColorPortfolian.backEnd)
        case .react     : return TagInfo(name: "React", color: ColorPortfolian.react)
        case .spring    : return TagInfo(name: "Spring", color: ColorPortfolian.spring)
        case .django    : return TagInfo(name: "Django", color: ColorPortfolian.django)
        case .javascript: return TagInfo(name: "Javascript", color: ColorPortfolian.javascript)
        case .typescript: return TagInfo(name: "Typescript", color: ColorPortfolian.typescript)
        case .ios       : return TagInfo(name: "iOS", color: ColorPortfolian.ios)
        case .android   : return TagInfo(name: "Andriod", color: ColorPortfolian.android)
        case .angular   : return TagInfo(name: "Angular", color: ColorPortfolian.angular)
        case .htmlCss   : return TagInfo(name: "HTML/CSS", color: ColorPortfolian.htmlCss)
        case .flask     : return TagInfo(name: "Flask", color: ColorPortfolian.flask)
        case .nodeJs    : return TagInfo(name: "Node.js", color: ColorPortfolian.nodeJs)
        case .java      : return TagInfo(name: "Java", color: ColorPortfolian.java)
        case .python    : return TagInfo(name: "Python", color: ColorPortfolian.python)
        case .kotlin    : return TagInfo(name: "Kotlin", color: ColorPortfolian.kotlin)
        case .swift     : return TagInfo(name: "Swift", color: ColorPortfolian.swift)
        case .go        : return TagInfo(name: "Go", color: ColorPortfolian.go)
        case .cCpp      : return TagInfo(name: "C/C++", color: ColorPortfolian.cCpp)
        case .cCsharp   : return TagInfo(name: "C#", color: ColorPortfolian.cCsharp)
        case .design    : return TagInfo(name: "Design", color: ColorPortfolian.design)
        case .figma     : return TagInfo(name: "Figma", color: ColorPortfolian.figma)
        case .sketch    : return TagInfo(name: "Sketch", color: ColorPortfolian.sketch)
        case .adobeXD   : return TagInfo(name: "adobeXD", color: ColorPortfolian.adobeXD)
        case .photoshop : return TagInfo(name: "Photoshop", color: ColorPortfolian.photoshop)
        case .illustrator: return TagInfo(name: "Illustrator", color: ColorPortfolian.illustrator)
        case .firebase  : return TagInfo(name: "Firebase", color: ColorPortfolian.firebase)
        case .aws       : return TagInfo(name: "AWS", color: ColorPortfolian.aws)
        case .gcp       : return TagInfo(name: "GCP", color: ColorPortfolian.gcp)
        case .git       : return TagInfo(name: "Git", color: ColorPortfolian.git)
        case .etc       : return TagInfo(name: "etc", color: ColorPortfolian.etc)
        default         : return TagInfo(name: "", color: ColorPortfolian.more)
        }
    }
}
