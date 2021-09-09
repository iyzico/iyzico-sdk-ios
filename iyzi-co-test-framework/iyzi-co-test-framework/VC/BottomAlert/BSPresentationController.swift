//
//  BSPresentationController.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 18.03.2021.
//

import UIKit

protocol BSPresentationControllerDataSource: AnyObject {
    func isContentLoaded() -> Bool
    func preferredContentHeight() -> CGFloat
}
    
class BSPresentationController: UIPresentationController {
    weak var dataSource: BSPresentationControllerDataSource?
    
    private lazy var dimmingView = makeDimmingView()
    private lazy var panGesture = makePanGesture()
    
    private var initialTranslation: CGPoint = .zero
    private var initialFrame: CGRect = .zero
    private var translationList: [CGFloat] = []
    
    private lazy var config: BSConfiguration? = {
        return (presentedViewController as? BottomSheetController)?.configuration
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let presenterView = self.containerView,
              let isContentLoaded = dataSource?.isContentLoaded(),
              isContentLoaded else {
            return super.frameOfPresentedViewInContainerView
        }
        
        let topMargin = config?.topMargin ?? 0.0
        let contentHeight = dataSource?.preferredContentHeight() ?? 0.0
        let bottomMargin = presenterView.safeAreaBottom
        var height = topMargin + contentHeight + bottomMargin
        
        let maxHeightPerc = config?.maxHeightPerc ?? 0.0
        let maxHeight = ceil(presenterView.frame.height * maxHeightPerc)
        if height > maxHeight {
            height = maxHeight
        }
        
        let origin = CGPoint(x: 0, y: presenterView.frame.height - height)
        let size = CGSize(width: presenterView.frame.width, height: height)
        
        return CGRect(origin: origin, size: size)
    }
    
    override func presentationTransitionWillBegin() {
        guard let presenterView = self.containerView,
              let presentedView = self.presentedView else {
            return
        }
        
        /// Add dimming view
        presenterView.addSubview(dimmingView)
        dimmingView.alpha = 0
        
        dimmingView.topAnchor.constraint(equalTo: presenterView.topAnchor).isActive = true
        dimmingView.leadingAnchor.constraint(equalTo: presenterView.leadingAnchor).isActive = true
        dimmingView.trailingAnchor.constraint(equalTo: presenterView.trailingAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: presenterView.bottomAnchor).isActive = true
        
        /// Corner radiıs
        presentedView.layer.masksToBounds = true
        presentedView.roundCorners(corners: [.topLeft, .topRight], radius: config?.cornerRadius ?? 0.0)
        
        /// Pan gesture
        if config?.dismissOnPull ?? false {
            presentedView.addGestureRecognizer(panGesture)
        }
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
             dimmingView.alpha = 1.0
             return
         }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
}

extension BSPresentationController {
    func updatePreferredContentHeight() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

private extension BSPresentationController {
    @objc func onTap(_ recognizer: UITapGestureRecognizer) {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func onDrag(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.presentedView)
        
        switch recognizer.state {
        case .began:
            
            initialTranslation = translation
            initialFrame = self.presentedView?.frame ?? .zero
            
        case .changed:
            
            let diff = translation.y - initialTranslation.y
            let ease: CGFloat = (diff < 0) ? 0.28 : 1
            let yPos = diff * ease
//            let yPos = initialFrame.origin.y + (diff*ease)
            
            presentedView?.frame.origin.y = initialFrame.origin.y + yPos
//            self.presentedViewController.view.transform = CGAffineTransform(translationX: 0, y: yPos)
            
            let newHeight = initialFrame.height + abs(yPos)
            if newHeight.isFinite && newHeight >= initialFrame.height {
                self.presentedView?.frame.size.height = newHeight
            }
            
            /// Gesture hisatory
            if translationList.count >= 5 { translationList.remove(at: 0) }
            translationList.append(translation.y)
            
        case .ended, .cancelled:
            
            self.panGesture.isEnabled = false
            if translation.y < 0 {
                self.animateBackIn()
            } else {
                if let currentPosY = translationList.first, let prePosY = translationList.last, currentPosY > prePosY {
                    self.animateBackIn()
                } else {
                    self.presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
            
        default: break
        }
    }
}

private extension BSPresentationController {
    func makeDimmingView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = config?.backgroundColor.withAlphaComponent(config?.backgroundAlpha ?? 0.0)
        view.isUserInteractionEnabled = true
        
        if config?.dismissOnBackground ?? false {
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(BSPresentationController.onTap(_:)))
            view.addGestureRecognizer(tapGesture)
        }
        
        return view
    }
    
    func makePanGesture() -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer(target: self,
                                             action: #selector(BSPresentationController.onDrag(_:)))
        return gesture
    }
    
    func animateBackIn() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.presentedView?.frame.origin = self.initialFrame.origin
            self.presentedView?.frame.size.height = self.initialFrame.size.height
//            self.presentedViewController.view.frame = self.initialFrame ?? .zero
//            self.presentedViewController.view.transform = .identity
        } completion: { [weak self] (_) in
            self?.panGesture.isEnabled = true
//            self?.presentedViewController.view.frame = self?.initialFrame ?? .zero
        }
    }
}

private extension UIView {
    func roundCorners3(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    var safeAreaBottom: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.bottom
        }
        return 0.0
    }
}
