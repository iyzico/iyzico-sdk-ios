//
//  AlertManager.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 20.12.2020.
//

import UIKit
import Lottie

class AlertManager: UIViewController {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lottieView: UIView!
    
    let animator = UIViewPropertyAnimator(duration: Constant.shared.AMDuration, curve: .linear)
   
    convenience init() {
        let bundle = Bundle(for: type(of: self))
        self.init(nibName: NibName.shared.alertManager, bundle: bundle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBlur()
        setUpLoadingView()
        setupLottieView()
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBlur()
    }
    
}
 // MARK: - SETUP
extension AlertManager {
    
    fileprivate func setUpLoadingView() {
        loadingView.layer.cornerRadius = Constant.shared.AMCornerRadius
    }
  
    private func setupLottieView() {
        let lottieManager = LottieManager.shared
        let animationView = lottieManager.getLottieViewWithoutPlaying(toView: lottieView,
                                                                      lottieType: .loading,
                                                                      contentMode: .scaleAspectFill,
                                                                      loopMode: .loop,
                                                                      shouldPlay: true)
        lottieView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: lottieView.topAnchor, constant: 0).isActive = true
        animationView.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor, constant: 0).isActive = true
        animationView.leadingAnchor.constraint(equalTo: lottieView.leadingAnchor, constant: 0).isActive = true
        animationView.trailingAnchor.constraint(equalTo: lottieView.trailingAnchor, constant: 0).isActive = true
        lottieManager.animationView.play()
    }

}
// MARK: - BLUR
extension AlertManager {
    
    fileprivate func addBlur() {
        view.addBlur(animator: animator)
    }
    
    fileprivate func removeBlur() {
        animator.stopAnimation(true)
        animator.finishAnimation(at: .current)
    }
}
