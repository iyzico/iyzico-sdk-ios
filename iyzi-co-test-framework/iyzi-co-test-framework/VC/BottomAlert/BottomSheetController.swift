//
//  BottomSheetController.swift
//  iyzi-co-test-framework
//
//  Created by Vural Çelik on 18.03.2021.
//

/**
 Usage:
 ```
 class MyViewController: UIViewController, BSPresentable {
     var modalContentHeight: CGFloat {
         return 300.0
     }
 }
 
 let vc = MyViewController()
 
 var config = BSConfiguration()
 config.cornerRadius = 12.0
 config...

 let bsController = BottomSheetController(contentViewController: vc, configuration: config)
 self.present(bsController, animated: true, completion: nil)
 ```
 */

import UIKit

class BottomSheetController: UIViewController {
    private var contentViewController: UIViewController
    private(set) var configuration: BSConfiguration
    
    private var isLoaded: Bool = false
    
    init(contentViewController: UIViewController, configuration: BSConfiguration?) {
        self.contentViewController = contentViewController
        self.configuration = configuration ?? BSConfiguration()
        super.init(nibName: nil, bundle: nil)
        
        if !(contentViewController is BSPresentable) {
            fatalError("BSPresentable not found!")
        }
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = configuration.contentBackgroundColor ?? contentViewController.view.backgroundColor

        self.addChild(contentViewController)
        self.view.addSubview(contentViewController.view)
        self.contentViewController.didMove(toParent: self)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: configuration.topMargin).isActive = true
        contentViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        contentViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
//        if #available(iOS 11.0, *) {
//            contentViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        } else {
//            contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        }
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isLoaded {
            isLoaded = true
            if let pc = presentationController as? BSPresentationController {
                pc.updatePreferredContentHeight()
            }
        }
    }

}

extension BottomSheetController: BSPresentationControllerDataSource {
    func isContentLoaded() -> Bool {
        return isLoaded
    }

    func preferredContentHeight() -> CGFloat {
        return (contentViewController as? BSPresentable)?.modalContentHeight ?? 0.0
    }
}

extension BottomSheetController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = BSPresentationController(presentedViewController: presented, presenting: presenting)
        controller.dataSource = self
        return controller
    }
}
