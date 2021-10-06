//
//  TLAlbumPopView.swift
//  TLPhotosPicker
//
//  Created by wade.hawk on 2017. 4. 19..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import UIKit

protocol PopupViewProtocol: AnyObject {
    var bgView: UIView! { get set }
    var popupView: UIView! { get set }
    var originalFrame: CGRect { get set }
    var show: Bool { get set }
    func setupPopupFrame()
    var subTitleArrowImageView: UIImageView! { get set }
}

extension PopupViewProtocol where Self: UIView {
    fileprivate func getFrame(offset: CGFloat) -> CGRect {
        var frame = self.originalFrame
//        frame.size.width = frame.size.width * scale
//        frame.size.height = frame.size.height * scale
//        frame.origin.x = self.frame.width/2 - frame.width/2
        frame.origin.y = offset
        return frame
    }
    func setupPopupFrame() {
        if self.originalFrame == CGRect.zero {
            self.originalFrame = self.popupView.frame
        }else {
            self.originalFrame.size.height = self.popupView.frame.height
        }
    }
    func show(_ show: Bool, duration: TimeInterval = 0.1) {
        if show {
            self.subTitleArrowImageView.image = TLBundle.podBundleImage(named: "nav_btn_dropup")
        }else {
            self.subTitleArrowImageView.image = TLBundle.podBundleImage(named: "nav_btn_dropdown")
        }
        guard self.show != show else { return }
        self.layer.removeAllAnimations()
        self.isHidden = false
        self.popupView.frame = show ? getFrame(offset: -self.popupView.frame.height) : self.popupView.frame
        self.bgView.alpha = show ? 0 : 1
        UIView.animate(withDuration: duration, animations: {
            self.bgView.alpha = show ? 1 : 0
            self.popupView.frame = show ? self.getFrame(offset: 0) : self.getFrame(offset: -self.popupView.frame.height)
        }) { _ in
            self.isHidden = show ? false : true
            self.show = show
//            UIView.animate(withDuration: duration) {
//                if show {
//                    self.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    self.popupView.frame = self.originalFrame
//                }
//                self.show = show
//            }
        }
    }
}

open class TLAlbumPopView: UIView, PopupViewProtocol {
    @IBOutlet open var bgView: UIView!
    @IBOutlet open var popupView: UIView!
    @IBOutlet var popupViewHeight: NSLayoutConstraint!
    @IBOutlet open var tableView: UITableView!
    @objc var originalFrame = CGRect.zero
    @objc var show = false
    
    weak var subTitleArrowImageView: UIImageView!
    
    deinit {
//        print("deinit TLAlbumPopView")
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
//        self.popupView.layer.cornerRadius = 5.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBgView))
        self.bgView.addGestureRecognizer(tapGesture)
        self.tableView.register(UINib(nibName: "TLCollectionTableViewCell", bundle: TLBundle.bundle()), forCellReuseIdentifier: "TLCollectionTableViewCell")
        self.tableView.separatorStyle = .none
        if #available(iOS 13.0, *) {
            self.popupView.backgroundColor = .systemBackground
        }
    }
    
    @objc func tapBgView() {
        self.show(false)
    }
}
