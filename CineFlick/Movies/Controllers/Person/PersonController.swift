//
//  PersonController.swift
//  CineFlick
//
//  Created by Josiah Agosto on 5/3/20.
//  Copyright © 2020 Josiah Agosto. All rights reserved.
//

import UIKit

class PersonController: UIViewController, SelectedPersonIdProtocol {
    // References / Properties
    public lazy var personView = PersonView()
    private lazy var personManager = PersonManager.shared
    public lazy var internetNetwork = InternetNetwork()
    var personId: String = ""
    
    override func loadView() {
        super.loadView()
        view = personView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        internetNetwork.checkForInternetConnectivity()
        fetchPersonRequest()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        personView.containerScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: personView.personBiography.frame.origin.y + personView.personBiography.frame.size.height + 5)
        personView.containerScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // MARK: - Private Functions
    private func setup() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setHidesBackButton(true, animated: true)
        setDismissButton()
    }
    
    
    private func setDismissButton() {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPersonController))
        saveBarButton.tintColor = UIColor(named: "TextColors")
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    private func fetchPersonRequest() {
        personManager.personRequest(with: personId) { (result) in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.personView.personBiography.text = self.personManager.personBiography
                    self.personView.personBirthDate.text = self.personManager.personBirthdate
                    self.personView.personPlaceOfBirth.text = self.personManager.personBirthPlace
                    self.personView.personProfession.text = self.personManager.personProfession
                    self.personView.personName.text = self.personManager.personName
                    self.personView.profilePicture.asynchronouslyLoadImage(with: self.personManager.personImageUrl)
                }
            case .failure(let error):
                NotificationController.displayError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func dismissPersonController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
