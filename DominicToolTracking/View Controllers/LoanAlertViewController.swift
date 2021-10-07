//
//  LoanAlertViewController.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 01/10/21.
//

import UIKit

class LoanAlertViewController: UIViewController {

    // passed variabels
    var selectedTool: Tool!
    
    private let defaultContainerHeight: CGFloat = 200
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.7
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(animateDismissView))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    // content
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Select Friend"
        textField.borderStyle = .roundedRect
        textField.tintColor = .clear
        textField.setUpToolbar()
        
        return textField
    }()
    
    lazy var saveButton: UIButton = {
       let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // constraint
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    // variables
    var delegate: LoanToolDelegate?
    
    private var friendList: [String] = []
    
    private let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.friendList = getFriendList()
    }
    
    private func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = .clear
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.delegate = self
        textField.inputView = pickerView
        
        disableSaveButton()
        
        titleLabel.text = "Loan - \(selectedTool.name)"
    }
    
    private func setupConstraint() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(saveButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // dimmed view
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // container View
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: self.defaultContainerHeight),
            
            // title label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            // textfield
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            // save button
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: self.defaultContainerHeight + 50)
        containerViewBottomConstraint?.isActive = true
    }
    
    @objc private func onKeyboardAppear(_ notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        let keyboardHeight = keyboardFrame.size.height + 20
        
        containerViewBottomConstraint?.constant = -keyboardHeight
        
        view.layoutIfNeeded()

    }

    @objc private func onKeyboardDisappear(_ notification: NSNotification) {
        let middleView = (screenSize.height / 2) - (self.defaultContainerHeight / 2)
        self.containerViewBottomConstraint?.constant = -middleView
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
        animateShowDimmedView()
    }
    
    func animatePresentContainer() {
        let middleView = (screenSize.height / 2) - (self.defaultContainerHeight / 2)
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = -middleView
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    @objc func animateDismissView() {
        textField.endEditing(true)
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultContainerHeight + 50
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func saveButtonTapped(_ sender: UIButton) {
        guard let friendName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        self.selectedTool.totalLoaned += 1
        
        delegate?.didLoaned(friendName: friendName,
                            tool: self.selectedTool)
        
        self.animateDismissView()
    }
    
    private func enableSaveButton() {
        saveButton.isEnabled = true
        saveButton.alpha = 1
    }
    
    private func disableSaveButton() {
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
    }

}

extension LoanAlertViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = friendList.first
        }
        else if let index = friendList.firstIndex(where: {$0 == textField.text}) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
            
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            self.disableSaveButton()
        }
        else {
            self.enableSaveButton()
        }
    }
}

extension LoanAlertViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        friendList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return friendList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = friendList[row]
    }
}
