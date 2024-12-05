//
//  ViewController.swift
//  PairPlay
//
//  Created by Matteo Orru on 05/12/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startScreenBackground = UIImageView(frame: self.view.bounds)
        startScreenBackground.image = UIImage(named: "startScreenBackground")
        startScreenBackground.contentMode = .scaleAspectFill
        startScreenBackground.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(startScreenBackground)
        
        
        NSLayoutConstraint.activate([
            startScreenBackground.topAnchor.constraint(equalTo: view.topAnchor),
            startScreenBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            startScreenBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startScreenBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        let startButton = UIButton(type: .system)
        startButton.setTitle("START", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        startButton.backgroundColor = UIColor.systemBlue
        startButton.layer.cornerRadius = 10
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
        
    }//viewDidLoad
    
    
    @objc func startButtonTapped() {
        //some code
    }

}

