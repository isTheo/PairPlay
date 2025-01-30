//
//  GameViewController.swift
//  PairPlay
//
//  Created by Matteo Orru on 09/12/24.
//

import UIKit
import Lottie


class GameViewController: UIViewController {
    private var animationView: LottieAnimationView?
    private var modelController: GameModelController
    private var scoreLabel: UILabel!
    private var currentScore: Int = 0
    private var consecutiveMatches: Int = 0
    private var revealedCards: [UIButton] = []
    private var cardBackImage: UIImage!
    private var currentLevel = 1
    
    init() {
        self.modelController = GameModelController(level: 1)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        cardBackImage = UIImage(named: "cardBack")
        setBackground()
        setupNavigationBar()
        setupGrid(rows: 4, columns: 2)
    }
    
    func setupNavigationBar() {
        // Home button
        let homeButton = UIBarButtonItem(image: UIImage(systemName: "house.fill"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(homeButtonTapped))
        homeButton.tintColor = .white
        navigationItem.leftBarButtonItem = homeButton
        
        // Level title
        let titleLabel = UILabel()
        titleLabel.text = "LEVEL \(currentLevel)"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Modak", size: 22)
        navigationItem.titleView = titleLabel
        
        // Right grid button
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "circle.grid.2x2.fill"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightButtonTapped))
        rightButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightButton
        
        // Score label under navbar
        scoreLabel = UILabel()
        scoreLabel.font = UIFont(name: "Modak", size: 28)
        scoreLabel.textColor = .white
        scoreLabel.text = "0"
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    
    
    @objc func homeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    @objc func rightButtonTapped() {
        currentLevel += 1
        if currentLevel > 3 {
            currentLevel = 1
        }
        
        view.subviews.forEach { $0.removeFromSuperview() }
        setBackground()
        setupNavigationBar()
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "LEVEL \(currentLevel)"
        }
        
        modelController = GameModelController(level: currentLevel)
        setupGrid(rows: getGridConfig(for: currentLevel).rows,
                  columns: getGridConfig(for: currentLevel).columns)
        revealedCards.removeAll()
        consecutiveMatches = 0
    }
    
    
    
    func setBackground() {
        let backgroundContainer = UIView(frame: view.bounds)
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundContainer)
        view.sendSubviewToBack(backgroundContainer)
        
        let backgroundImage = UIImageView(frame: backgroundContainer.bounds)
        backgroundImage.image = UIImage(named: "memoMatchBG")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.addSubview(backgroundImage)
        
        let overlayView = UIView(frame: backgroundContainer.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            overlayView.topAnchor.constraint(equalTo: backgroundContainer.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor)
        ])
    }
    
    
    
    func setupGrid(rows: Int, columns: Int) {
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.alignment = .fill
        gridStackView.spacing = 20
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridStackView)
        
        let spacing: CGFloat = 8 * CGFloat(columns - 1)
        let availableWidth = view.bounds.width * 0.9 - spacing
        let cardSize = availableWidth / CGFloat(columns)
        
        if currentLevel == 1 {
            NSLayoutConstraint.activate([
                gridStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 68),
                gridStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -68),
                gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                gridStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                gridStackView.heightAnchor.constraint(equalToConstant: cardSize * CGFloat(rows) + (12 * CGFloat(rows - 1)))
            ])
        } else {
            NSLayoutConstraint.activate([
                gridStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                gridStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                gridStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                gridStackView.heightAnchor.constraint(equalToConstant: cardSize * CGFloat(rows) + (12 * CGFloat(rows - 1)))
            ])
        }
        
        var imageIndex = 0
        
        for _ in 0..<rows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 8
            
            for _ in 0..<columns {
                if imageIndex < modelController.cardImages.count {
                    let button = UIButton(type: .system)
                    button.clipsToBounds = false
                    button.layer.shadowOffset = CGSize(width: 0, height: 4)
                    button.layer.shadowRadius = 6
                    button.layer.shadowOpacity = 0.5
                    button.tag = imageIndex
                    button.addTarget(self, action: #selector(cardTapped(_:)), for: .touchUpInside)
                    button.setBackgroundImage(cardBackImage, for: .normal)
                    button.imageView?.contentMode = .scaleAspectFill
                    button.contentMode = .scaleAspectFill
                    
                    imageIndex += 1
                    rowStackView.addArrangedSubview(button)
                }
            }
            gridStackView.addArrangedSubview(rowStackView)
        }
    }
    
    
    
    @objc func cardTapped(_ sender: UIButton) {
        guard revealedCards.count < 2 else { return }
        
        let imageIndex = sender.tag
        if imageIndex < modelController.cardImages.count {
            let image = modelController.cardImages[imageIndex]
            
            UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                let resizedImage = self.resizeImage(image: image, targetSize: sender.bounds.size)
                sender.setBackgroundImage(resizedImage, for: .normal)
            }, completion: nil)
            
            sender.isEnabled = false
            revealedCards.append(sender)
            
            if revealedCards.count == 2 {
                checkMatch()
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? image
    }
    
    func checkMatch() {
        guard revealedCards.count == 2 else { return }
        
        let firstCard = revealedCards[0]
        let secondCard = revealedCards[1]
        
        if modelController.isMatch(firstIndex: firstCard.tag, secondIndex: secondCard.tag) {
            consecutiveMatches += 1
            let points = 2 * Int(pow(2.0, Double(consecutiveMatches - 1)))
            currentScore += points
            scoreLabel.text = "\(currentScore)"
            
            showPointsAnimation(points)
            
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
                firstCard.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                secondCard.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                firstCard.alpha = 0
                secondCard.alpha = 0
            }, completion: { _ in
                firstCard.transform = .identity
                secondCard.transform = .identity
                firstCard.isUserInteractionEnabled = false
                secondCard.isUserInteractionEnabled = false
                self.revealedCards.removeAll()
                
                if self.allPairsMatched() {
                    let animation = LottieAnimation.named("star")
                    self.animationView = LottieAnimationView(animation: animation)
                    
                    if let animationView = self.animationView {
                        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                        animationView.center = self.view.center
                        animationView.contentMode = .scaleAspectFit
                        animationView.loopMode = .playOnce
                        
                        self.view.addSubview(animationView)
                        animationView.play { completed in
                            if completed {
                                self.levelCompleted()
                            }
                        }
                    }
                }
            })
        } else {
            consecutiveMatches = 0
            handleMismatchedCards(revealedCards)
        }
    }
    
    
    
    private func showPointsAnimation(_ points: Int) {
        let pointsLabel = UILabel()
        pointsLabel.text = "+\(points)"
        pointsLabel.font = UIFont(name: "Modak", size: 44)
        pointsLabel.textColor = .orange
        
        // Aggiungi il contorno nero
        pointsLabel.layer.shadowColor = UIColor.black.cgColor
        pointsLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        pointsLabel.layer.shadowRadius = 0
        pointsLabel.layer.shadowOpacity = 1.0
        pointsLabel.layer.masksToBounds = false
        pointsLabel.layer.shouldRasterize = true
        pointsLabel.layer.rasterizationScale = UIScreen.main.scale
        
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pointsLabel)
        
        NSLayoutConstraint.activate([
            pointsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pointsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        
        UIView.animate(withDuration: 0.9, animations: {
            pointsLabel.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            pointsLabel.alpha = 0
            pointsLabel.transform = pointsLabel.transform.translatedBy(x: 0, y: -20)
        }) { _ in
            pointsLabel.removeFromSuperview()
        }
    }
    
    
    
    private func handleMismatchedCards(_ cards: [UIButton]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            cards.forEach { card in
                UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    card.setBackgroundImage(self.cardBackImage, for: .normal)
                }, completion: nil)
                card.isEnabled = true
            }
            self.revealedCards.removeAll()
        }
    }
    
    
    
    func allPairsMatched() -> Bool {
        for subview in view.subviews {
            if let gridStackView = subview as? UIStackView {
                for rowSubview in gridStackView.arrangedSubviews {
                    if let rowStackView = rowSubview as? UIStackView {
                        for buttonSubview in rowStackView.arrangedSubviews {
                            if let button = buttonSubview as? UIButton, button.isEnabled {
                                return false
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    
    
    
    func levelCompleted() {
        currentLevel += 1
        consecutiveMatches = 0
        
        if currentLevel > 3 {
            showGameClearedMessage()
            return
        }
        
        UIView.transition(with: self.view, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.view.subviews.forEach { $0.removeFromSuperview() }
            self.setBackground()
            self.setupNavigationBar()
            
            if let titleLabel = self.navigationItem.titleView as? UILabel {
                titleLabel.text = "LEVEL \(self.currentLevel)"
            }
            
            self.modelController = GameModelController(level: self.currentLevel)
            self.setupGrid(rows: self.getGridConfig(for: self.currentLevel).rows,
                           columns: self.getGridConfig(for: self.currentLevel).columns)
            self.revealedCards.removeAll()
        }, completion: nil)
    }
    
    
    
    private func getGridConfig(for level: Int) -> (rows: Int, columns: Int) {
        switch level {
        case 1: return (4, 2)
        case 2: return (4, 3)
        case 3: return (4, 4)
        default: return (4, 4)
        }
    }
    
    
    
    private func showGameClearedMessage() {
        let finalLabel = UILabel()
        finalLabel.text = "Game Cleared.\nCongratulations!"
        finalLabel.textColor = .white
        finalLabel.font = UIFont(name: "Modak", size: 44)
        finalLabel.numberOfLines = 2
        finalLabel.textAlignment = .center
        finalLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(finalLabel)
        
        NSLayoutConstraint.activate([
            finalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finalLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        addPulseAnimation(to: finalLabel)
    }
    
    
    
    private func addPulseAnimation(to label: UILabel) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        label.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    
    
    
}
