//
//  FilterViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/22.
//

import UIKit

class FilterViewController: UIViewController, TagToggleButtonDelegate {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let frontEndButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Front-end", fontSize: 16)
        button.setColor(color: ColorPortfolian.frontEnd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backEndButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: " Back-end", fontSize: 16)
        button.setColor(color: ColorPortfolian.backEnd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let reactButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: " React", fontSize: 16)
        button.setColor(color: ColorPortfolian.react)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let vueButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: " Vue", fontSize: 16)
        button.setColor(color: ColorPortfolian.vue)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let springButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: " Spring", fontSize: 16)
        button.setColor(color: ColorPortfolian.spring)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let djangoButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: " Django", fontSize: 16)
        button.setColor(color: ColorPortfolian.django)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let javaScriptButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Javascript", fontSize: 16)
        button.setColor(color: ColorPortfolian.javascript)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let typeScriptButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Typescript", fontSize: 16)
        button.setColor(color: ColorPortfolian.typescript)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let iosButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "iOS", fontSize: 16)
        button.setColor(color: ColorPortfolian.ios)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let androidButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Android", fontSize: 16)
        button.setColor(color: ColorPortfolian.android)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let angularButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Angular", fontSize: 16)
        button.setColor(color: ColorPortfolian.angular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let htmlCssButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "HTML/CSS", fontSize: 16)
        button.setColor(color: ColorPortfolian.htmlCss)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let flaskButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Flask", fontSize: 16)
        button.setColor(color: ColorPortfolian.flask)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nodeButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Node.js", fontSize: 16)
        button.setColor(color: ColorPortfolian.nodeJs)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let javaButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Java", fontSize: 16)
        button.setColor(color: ColorPortfolian.java)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pythonButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Python", fontSize: 16)
        button.setColor(color: ColorPortfolian.python)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let kotlinButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Kotlin", fontSize: 16)
        button.setColor(color: ColorPortfolian.kotlin)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let swiftButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Swift", fontSize: 16)
        button.setColor(color: ColorPortfolian.swift)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let goButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Go", fontSize: 16)
        button.setColor(color: ColorPortfolian.go)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cCppButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "C/C++", fontSize: 16)
        button.setColor(color: ColorPortfolian.cCpp)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cCsharpButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "C#", fontSize: 16)
        button.setColor(color: ColorPortfolian.cCsharp)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let designButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Design", fontSize: 16)
        button.setColor(color: ColorPortfolian.design)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let figmaButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Figma", fontSize: 16)
        button.setColor(color: ColorPortfolian.figma)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sketchButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Sketch", fontSize: 16)
        button.setColor(color: ColorPortfolian.sketch)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let adobeXDButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "adobeXD", fontSize: 16)
        button.setColor(color: ColorPortfolian.adobeXD)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let photoshopButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Photoshop", fontSize: 16)
        button.setColor(color: ColorPortfolian.photoshop)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let illustratorButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Illustrator", fontSize: 16)
        button.setColor(color: ColorPortfolian.illustrator)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let firebaseButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Firebase", fontSize: 16)
        button.setColor(color: ColorPortfolian.firebase)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let awsButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "AWS", fontSize: 16)
        button.setColor(color: ColorPortfolian.aws)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let gcpButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "GCP", fontSize: 16)
        button.setColor(color: ColorPortfolian.gcp)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let gitButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "Git", fontSize: 16)
        button.setColor(color: ColorPortfolian.git)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let etcButton: TagButton = {
        let button = TagButton()
        button.informTextInfo(text: "etc", fontSize: 16)
        button.setColor(color: ColorPortfolian.etc)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "태그 필터"
        addSubview()
        setupAutoLayout()
        // Do any additional setup after loading the view.
        didTouchTagButton(didClicked: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    //MARK: - setupAutoLayout
    func setupAutoLayout() {
        definesPresentationContext = true
        NSLayoutConstraint.activate([
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        frontEndButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
        frontEndButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        backEndButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
        backEndButton.leadingAnchor.constraint(equalTo: frontEndButton.trailingAnchor, constant: 20),
        
        reactButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20),
        reactButton.leadingAnchor.constraint(equalTo: backEndButton.trailingAnchor, constant: 20),
        
        vueButton.topAnchor.constraint(equalTo: frontEndButton.bottomAnchor, constant: 20),
        vueButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        springButton.topAnchor.constraint(equalTo: frontEndButton.bottomAnchor, constant: 20),
        springButton.leadingAnchor.constraint(equalTo: vueButton.trailingAnchor, constant: 20),
        
        djangoButton.topAnchor.constraint(equalTo: frontEndButton.bottomAnchor, constant: 20),
        djangoButton.leadingAnchor.constraint(equalTo: springButton.trailingAnchor, constant: 20),
        
        javaScriptButton.topAnchor.constraint(equalTo: frontEndButton.bottomAnchor, constant: 20),
        javaScriptButton.leadingAnchor.constraint(equalTo: djangoButton.trailingAnchor, constant: 20),
        
        typeScriptButton.topAnchor.constraint(equalTo: vueButton.bottomAnchor, constant: 20),
        typeScriptButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        iosButton.topAnchor.constraint(equalTo: vueButton.bottomAnchor, constant: 20),
        iosButton.leadingAnchor.constraint(equalTo: typeScriptButton.trailingAnchor, constant: 20),
        
        androidButton.topAnchor.constraint(equalTo: vueButton.bottomAnchor, constant: 20),
        androidButton.leadingAnchor.constraint(equalTo: iosButton.trailingAnchor, constant: 20),
        
        angularButton.topAnchor.constraint(equalTo: vueButton.bottomAnchor, constant: 20),
        angularButton.leadingAnchor.constraint(equalTo: androidButton.trailingAnchor, constant: 20),
        
        htmlCssButton.topAnchor.constraint(equalTo: typeScriptButton.bottomAnchor, constant: 20),
        htmlCssButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        flaskButton.topAnchor.constraint(equalTo: typeScriptButton.bottomAnchor, constant: 20),
        flaskButton.leadingAnchor.constraint(equalTo: htmlCssButton.trailingAnchor, constant: 20),
        
        nodeButton.topAnchor.constraint(equalTo: typeScriptButton.bottomAnchor, constant: 20),
        nodeButton.leadingAnchor.constraint(equalTo: flaskButton.trailingAnchor, constant: 20),
        
        javaButton.topAnchor.constraint(equalTo: typeScriptButton.bottomAnchor, constant: 20),
        javaButton.leadingAnchor.constraint(equalTo: nodeButton.trailingAnchor, constant: 20),
        
        pythonButton.topAnchor.constraint(equalTo: htmlCssButton.bottomAnchor, constant: 20),
        pythonButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        kotlinButton.topAnchor.constraint(equalTo: htmlCssButton.bottomAnchor, constant: 20),
        kotlinButton.leadingAnchor.constraint(equalTo: pythonButton.trailingAnchor, constant: 20),
        
        swiftButton.topAnchor.constraint(equalTo: htmlCssButton.bottomAnchor, constant: 20),
        swiftButton.leadingAnchor.constraint(equalTo: kotlinButton.trailingAnchor, constant: 20),
        
        goButton.topAnchor.constraint(equalTo: htmlCssButton.bottomAnchor, constant: 20),
        goButton.leadingAnchor.constraint(equalTo: swiftButton.trailingAnchor, constant: 20),
        
        cCppButton.topAnchor.constraint(equalTo: pythonButton.bottomAnchor, constant: 20),
        cCppButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        cCsharpButton.topAnchor.constraint(equalTo: pythonButton.bottomAnchor, constant: 20),
        cCsharpButton.leadingAnchor.constraint(equalTo: cCppButton.trailingAnchor, constant: 20),
        
        designButton.topAnchor.constraint(equalTo: pythonButton.bottomAnchor, constant: 20),
        designButton.leadingAnchor.constraint(equalTo: cCsharpButton.trailingAnchor, constant: 20),
        
        figmaButton.topAnchor.constraint(equalTo: pythonButton.bottomAnchor, constant: 20),
        figmaButton.leadingAnchor.constraint(equalTo: designButton.trailingAnchor, constant: 20),
        
        sketchButton.topAnchor.constraint(equalTo: cCppButton.bottomAnchor, constant: 20),
        sketchButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        adobeXDButton.topAnchor.constraint(equalTo: cCppButton.bottomAnchor, constant: 20),
        adobeXDButton.leadingAnchor.constraint(equalTo: sketchButton.trailingAnchor, constant: 20),
        
        photoshopButton.topAnchor.constraint(equalTo: cCppButton.bottomAnchor, constant: 20),
        photoshopButton.leadingAnchor.constraint(equalTo: adobeXDButton.trailingAnchor, constant: 20),
        
        illustratorButton.topAnchor.constraint(equalTo: sketchButton.bottomAnchor, constant: 20),
        illustratorButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        firebaseButton.topAnchor.constraint(equalTo: sketchButton.bottomAnchor, constant: 20),
        firebaseButton.leadingAnchor.constraint(equalTo: illustratorButton.trailingAnchor, constant: 20),
        
        awsButton.topAnchor.constraint(equalTo: sketchButton.bottomAnchor, constant: 20),
        awsButton.leadingAnchor.constraint(equalTo: firebaseButton.trailingAnchor, constant: 20),
        
        gcpButton.topAnchor.constraint(equalTo: illustratorButton.bottomAnchor, constant: 20),
        gcpButton.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        
        gitButton.topAnchor.constraint(equalTo: illustratorButton.bottomAnchor, constant: 20),
        gitButton.leadingAnchor.constraint(equalTo: gcpButton.trailingAnchor, constant: 20),
        
        etcButton.topAnchor.constraint(equalTo: illustratorButton.bottomAnchor, constant: 20),
        etcButton.leadingAnchor.constraint(equalTo: gitButton.trailingAnchor, constant: 20),
             
        
        ])
    }
    
    //MARK: - addSubview
    func addSubview() {
        view.addSubview(containerView)
        containerView.addSubview(frontEndButton)
        containerView.addSubview(backEndButton)
        containerView.addSubview(reactButton)
        containerView.addSubview(vueButton)
        containerView.addSubview(springButton)
        containerView.addSubview(djangoButton)
        containerView.addSubview(javaScriptButton)
        containerView.addSubview(typeScriptButton)
        containerView.addSubview(iosButton)
        containerView.addSubview(androidButton)
        containerView.addSubview(angularButton)
        containerView.addSubview(htmlCssButton)
        containerView.addSubview(flaskButton)
        containerView.addSubview(nodeButton)
        containerView.addSubview(javaButton)
        containerView.addSubview(pythonButton)
        containerView.addSubview(kotlinButton)
        containerView.addSubview(swiftButton)
        containerView.addSubview(goButton)
        containerView.addSubview(cCppButton)
        containerView.addSubview(cCsharpButton)
        containerView.addSubview(designButton)
        containerView.addSubview(figmaButton)
        containerView.addSubview(sketchButton)
        containerView.addSubview(adobeXDButton)
        containerView.addSubview(photoshopButton)
        containerView.addSubview(illustratorButton)
        containerView.addSubview(firebaseButton)
        containerView.addSubview(awsButton)
        containerView.addSubview(gcpButton)
        containerView.addSubview(gitButton)
        containerView.addSubview(etcButton)
    }
    
    func didTouchTagButton(didClicked: Bool) {
        frontEndButton.delegate = self
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
