//
//  LottieManager.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.02.2021.
//

import Foundation
import Lottie

class LottieManager {
    
    static let shared = LottieManager()
    
    let animationView = AnimationView()
    
    func getLottieView(toView: UIView,
                       lottieType: LottieFiles,
                       contentMode: UIView.ContentMode,
                       loopMode: LottieLoopMode,
                       shouldPlay: Bool = true) -> AnimationView {
        let animationView = AnimationView()
        animationView.animation = getLottieAnimation(lottieType: lottieType)
        animationView.frame = toView.bounds
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }
    
    func getLottieViewWithoutPlaying(toView: UIView,
                                     lottieType: LottieFiles,
                                     contentMode: UIView.ContentMode,
                                     loopMode: LottieLoopMode,
                                     shouldPlay: Bool = true) -> AnimationView {
        animationView.animation = getLottieAnimation(lottieType: lottieType)
        animationView.frame = toView.bounds
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
//        animationView.play()
        return animationView
    }
    
    private func getLottieAnimation(lottieType: LottieFiles) -> Animation? {
        let path = Bundle(for: type(of: self)).path(forResource: lottieType.getFileName(),
                                          ofType: "json") ?? ""
        return Animation.filepath(path)
    }
}

