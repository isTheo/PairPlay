//
//  ViewController.swift
//  PairPlay
//
//  Created by Matteo Orru on 09/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var startButton: UIButton!
    private var startButtonBottomConstraint: NSLayoutConstraint!
    private var startButtonLeadingConstraint: NSLayoutConstraint!
    private var backgroundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupStartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addPulseAnimation(to: startButton)
    }
    
    private func setupBackground() {
        backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "memoMatchBG")
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupStartButton() {
        startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Modak", size: 54)
        startButton.layer.cornerRadius = 10
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        startButton.layer.shadowRadius = 7
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        setupStartButtonConstraints()
    }

    private func addPulseAnimation(to button: UIButton) {
        if button.layer.animation(forKey: "pulse") == nil {
            let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulseAnimation.duration = 1.0
            pulseAnimation.fromValue = 1.0
            pulseAnimation.toValue = 1.1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = .infinity
            button.layer.add(pulseAnimation, forKey: "pulse")
        }
    }
    
    private func setupStartButtonConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        startButtonLeadingConstraint = startButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80)
        startButtonBottomConstraint = startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            startButtonLeadingConstraint,
            startButtonBottomConstraint,
            startButton.widthAnchor.constraint(equalToConstant: 210),
            startButton.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func updateStartButtonPositionAndSize(offsetX: CGFloat, offsetY: CGFloat, width: CGFloat, height: CGFloat) {
        startButtonLeadingConstraint.constant = offsetX
        startButtonBottomConstraint.constant = -offsetY
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: width),
            startButton.heightAnchor.constraint(equalToConstant: height),
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func startButtonTapped() {
        animateStartTransition {
            let gameViewController = GameViewController()
            
            UIView.transition(with: self.navigationController!.view, duration: 1.5, options: .transitionCrossDissolve, animations: {
                self.navigationController?.pushViewController(gameViewController, animated: false)
            }, completion: nil)
        }
    }
    
    

    private func animateStartTransition(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 2.5, animations: {
            self.backgroundImageView.alpha = 1
        }, completion: { _ in
            completion()
        })
    }

    
    
    
    
    
}
