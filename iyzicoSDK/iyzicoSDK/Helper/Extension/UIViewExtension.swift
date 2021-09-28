//
//  UIViewExtension.swift
//  iyzicoSDK
//
//  Created by Tolga İskender on 8.12.2020.
//

import Foundation
import UIKit

extension UIView {
    
    func addBorder(borderWidth: CGFloat = 1, borderColor: CGColor = UIColor.clearBlue.cgColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor  = borderColor
    }
    
    func addExternalBorder(borderWidth: CGFloat = 3.0, borderColor: UIColor = UIColor.lightSkyBlue)  {
        let externalBorder = CALayer()
        externalBorder.frame = CGRect(x: -borderWidth,
                                      y: -borderWidth,
                                      width: self.frame.size.width + (borderWidth * 2),
                                      height: self.frame.size.height + (borderWidth * 2))
        externalBorder.borderColor = borderColor.cgColor
        externalBorder.borderWidth = borderWidth
        externalBorder.name = StringConstant.shared.externalBorderName
        externalBorder.cornerRadius = Constant.shared.textInputCornerRadius + 2
     
        self.layer.insertSublayer(externalBorder, at: 0)
        self.layer.masksToBounds = false
    }
    
    func removeExternalBorders() {
        layer.sublayers?.filter() { $0.name ==  StringConstant.shared.externalBorderName }.forEach() {
            $0.removeFromSuperlayer()
        }
    }
    
    func dropShadow(color: UIColor,
                    opacity: Float = 0.5,
                    offSet: CGSize,
                    radius: CGFloat = 1,
                    scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0.0
    }
    
    func addBlur(animator: UIViewPropertyAnimator) {
        let effectView = UIVisualEffectView(effect: nil)
        self.backgroundColor = .darkGreyWithAlpha08
        self.addSubview(effectView)
        effectView.constraintToSuperView()
        self.sendSubviewToBack(effectView)
        animator.addAnimations {
            effectView.effect = UIBlurEffect(style: .dark)
        }
        animator.fractionComplete = 0.12
    }
    
    func removeBlurred() {
        if self.superview?.subviews.count ?? 0 > 1 {
            for subview in self.superview!.subviews {
                if subview is UIVisualEffectView {
                    subview.removeFromSuperview()
                    self.superview?.backgroundColor = .clear
                    return
                }
            }
        }
        
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
                self.backgroundColor = .clear
                return
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func roundCorners2(with CACornerMask: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [CACornerMask]
    }
    
    func constraintToSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superView = superview else { print("nil2"); return }
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor,constant: 0),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor,constant: 0),
            self.topAnchor.constraint(equalTo: superView.topAnchor,constant: 0),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor,constant: 0)
        ])
    }
    
    //MARK: - Animations
    func addRotateAnimation(rotation: String = "transform.rotation.z") {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: rotation)
        rotation.toValue = NSNumber(value: (Double.pi * 2) * -1)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func addRotateAnimationNew(withDuration: Double,
                               completionHandler: @escaping () -> Void) {
        let rotationKeyPath = "transform.rotation.z"
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: rotationKeyPath)
        rotation.toValue = NSNumber(value: (Double.pi * 2) * -1)
        rotation.duration = withDuration
        rotation.isCumulative = true
        rotation.repeatCount = 1
        rotation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.layer.add(rotation, forKey: "rotationAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration) {
            completionHandler()
        }
    }
    
    func removeRotateAnimation() {
        self.layer.removeAllAnimations()
        self.superview?.layoutIfNeeded()
    }
    
    func fadeAnimation(shouldAppear: Bool,
                       delay: Double = 0.0,
                       completionHandler: (() -> Void)? = nil) {
        var tempShouldAppear = shouldAppear
        UIView.animate(withDuration: 1.2,
                       delay: 0.0,
                       options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.alpha = self.getAlphaForFadeAnimation(shouldAppear: tempShouldAppear)
            tempShouldAppear.toggle()
        } completion: { (success) in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    UIView.animate(withDuration: 1.2,
                                   delay: 0.0,
                                   options: .curveEaseOut) { [weak self] in
                        guard let self = self else { return }
                        self.alpha = self.getAlphaForFadeAnimation(shouldAppear: tempShouldAppear)
                        completionHandler?()
                    }
                }
            }
        }
    }

    private func getAlphaForFadeAnimation(shouldAppear: Bool) -> CGFloat {
        return shouldAppear ? 1.0 : 0.0
    }
}
