//
//  CollectionViewController.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.12.2022.
//


import UIKit
import SnapKit
import PBPopupController

class CollectionViewController: UIViewController {
    
    var popupContentVC: PopupContentViewController!
    weak var containerVC: UIViewController!
    var popupPlayButtonItem: UIBarButtonItem!
    var popupNextButtonItem: UIBarButtonItem!
    
    let titles = ["Respect", "Fight the Power", "A Change Is Gonna Come", "Like a Rolling Stone", "Smells Like Teen Spirit", "What’s Going On", "Strawberry Fields Forever", "Get Ur Freak On", "Dreams", "Hey Ya!", "God Only Knows", "Superstition", "Gimme Shelter", "Waterloo Sunset", "I Want to Hold Your Hand", "Crazy in Love", "Bohemian Rhapsody", "Purple Rain"]
    
    var collectionView: UICollectionView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupContainerVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        
        if let containerVC = self.containerVC, let popupContentView = containerVC.popupContentView {
            popupContentView.popupContentSize = CGSize(width: -1, height: self.containerVC.view.bounds.height * 0.85)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.popupContentVC = PopupContentViewController()
        
        self.commonSetup()
        self.createBarButtonItems()
        
        if self.containerVC.popupController.popupPresentationState == .closed {
            // Present the popup bar with another popup
             self.presentPopupBar(self)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.setupTextLabel(labelText: titles[indexPath.row])
        
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3.4, height: view.frame.size.width / 3.4)
    }
}

extension CollectionViewController {
    
    func collectionView( _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        displayItemOnTapByIndexPath(indexPath: indexPath)
        return false
    }
}

extension CollectionViewController {
    
    // Setup Collections
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        view.addSubview(collectionView!)
    }
    
    // Press Cell
    private func displayItemOnTapByIndexPath(indexPath: IndexPath){
        self.updatePopupBar(forRowAt: indexPath.row)
        self.presentPopupBar(self)
    }
}

// MARK: - PBPopup
extension CollectionViewController: PBPopupControllerDataSource, PBPopupControllerDelegate, PBPopupBarDataSource, PBPopupBarPreviewingDelegate {
    
    func setupContainerVC() {
        if let navigationController = self.navigationController as? NavigationController {
            self.containerVC = navigationController
            if let containerController = navigationController.parent {
                self.containerVC = containerController
            }
        } else {
            self.containerVC = self
        }
    }
    
    func commonSetup() {
        if (self.containerVC?.popupBar) != nil {
            self.containerVC.popupController.delegate = self
            if let popupContentView = self.containerVC.popupContentView {
                popupContentView.popupIgnoreDropShadowView = false
                popupContentView.popupPresentationDuration = 0.4
                popupContentView.popupCanDismissOnPassthroughViews = true
            }
            self.collectionView?.reloadData()
        }
    }
    
    func createBarButtonItems() {
        self.popupPlayButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: nil, action: nil)
        self.popupNextButtonItem = UIBarButtonItem(image: UIImage(systemName: "forward.fill"), style: .plain, target: nil, action: nil)
        
        self.configureBarButtonItems()
    }
    
    func configureBarButtonItems() {
        if let popupBar = self.containerVC.popupBar {
            popupBar.leftBarButtonItems = nil
            popupBar.rightBarButtonItems = nil
            if UIDevice.current.userInterfaceIdiom == .phone {
                if popupBar.popupBarStyle == .prominent {
                    popupBar.leftBarButtonItems = nil
                    popupBar.rightBarButtonItems = [self.popupPlayButtonItem, self.popupNextButtonItem]
                }
            }
            self.popupPlayButtonItem.action = #selector(self.playPauseAction(_:))
            self.popupNextButtonItem.action = #selector(self.nextAction(_:))
        }
    }
    
    @objc func presentPopupBar(_ sender: Any){
        self.commonSetup()
        self.setupPopupBar()
        self.configureBarButtonItems()
        
        DispatchQueue.main.async {
            self.containerVC.presentPopupBar(withPopupContentViewController: self.popupContentVC, animated: true, completion: {
                print("Popup Bar Presented")
            })
        }
    }
    
    private func updatePopupBar(forRowAt index: Int) {
        self.containerVC.popupBar.image = UIImage(systemName: "headphones")
        self.containerVC.popupBar.title = titles[index]
        self.containerVC.popupBar.subtitle = "Track subtitle"
    }
    
    func setupPopupBar(){
        if let popupBar = self.containerVC.popupBar {
            popupBar.PBPopupBarShowColors = false
            popupBar.dataSource = self
            popupBar.previewingDelegate = self
            
            popupBar.inheritsVisualStyleFromBottomBar = true
            popupBar.shadowImageView.shadowOpacity = 0
            popupBar.borderViewStyle = .none
        }
    }
    
    @objc func playPauseAction(_ sender: Any?) {
        print("playPauseAction")
    }
    
    @objc func nextAction(_ sender: Any) {
        print("nextAction")
    }
}
