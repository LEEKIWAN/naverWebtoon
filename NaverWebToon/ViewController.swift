//
//  ViewController.swift
//  NaverWebToon
//
//  Created by kiwan on 2020/01/08.
//  Copyright © 2020 kiwan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageList = [UIImage(named: "Unknown-1"), UIImage(named: "Unknown-2"), UIImage(named: "Unknown-3"), UIImage(named: "Unknown-4"), UIImage(named: "Unknown-5"), UIImage(named: "Unknown-6"), UIImage(named: "Unknown-7"), UIImage(named: "Unknown-8"), UIImage(named: "Unknown-9"), UIImage(named: "Unknown-10"), UIImage(named: "Unknown-11"), UIImage(named: "Unknown-12"), UIImage(named: "Unknown-13"), UIImage(named: "Unknown-14"), UIImage(named: "Unknown-1"), UIImage(named: "Unknown-2"), UIImage(named: "Unknown-3"), UIImage(named: "Unknown-4"), UIImage(named: "Unknown-5"), UIImage(named: "Unknown-6"), UIImage(named: "Unknown-7"), UIImage(named: "Unknown-8"), UIImage(named: "Unknown-9"), UIImage(named: "Unknown-10"), UIImage(named: "Unknown-11"), UIImage(named: "Unknown-12"), UIImage(named: "Unknown-13"), UIImage(named: "Unknown-14")]
    let titleList = ["동해물과 백두산이 마륵고 닳도록 하느님이 보우하사 우리나라만세", "@IBOutlet@IBOutlet@IBOutlet@IBOutlet@IBOutlet@IBOutlet@IBOutlet@IBOutlet@IBOutlet", "mageUIImageUIImageUIImageUIImage"]
    let writerList = ["Steve Jobs", "ㅎㅇ", "First"]
    let viewCountList = ["조회수 9.3천회", "조회수 10.3만회", "조회수 2천회"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var consImageTopMargin: NSLayoutConstraint!
    @IBOutlet weak var consHiddenNaviBar: NSLayoutConstraint!
    @IBOutlet weak var consDayTopMargin: NSLayoutConstraint!
    
    
    private var barStyle: UIStatusBarStyle = .lightContent {
        willSet {
            UIView.animate(withDuration: 0.2) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if topAnimationFlag == true {
            return
        }
        
        let currentHiddenNaviH: CGFloat = consHiddenNaviBar.constant
        let currentDayTopH: CGFloat = consDayTopMargin.constant
    
        let offset = scrollView.contentOffset;
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
            
        
        if(currentDayTopH > 0){
            consHiddenNaviBar.constant = -20
            consDayTopMargin.constant = 0
            barStyle = .lightContent
        }
        else {
            if consHiddenNaviBar.constant < 95 {
                if(-currentHiddenNaviH - offset.y > 95) {
                    consHiddenNaviBar.constant = 95
                    consDayTopMargin.constant = -115
                }
                else {
                    consHiddenNaviBar.constant = -currentHiddenNaviH - offset.y
                    consDayTopMargin.constant = currentDayTopH - offset.y
                }
                scrollView.contentOffset = CGPoint.zero
                barStyle = .lightContent
                
            }
            else if offset.y < 0 {
                consHiddenNaviBar.constant = -currentHiddenNaviH - offset.y
                consDayTopMargin.constant = currentDayTopH - offset.y
                barStyle = .darkContent
            }
            else if offset.y > 0 {
                consHiddenNaviBar.constant = 95
                barStyle = .darkContent
            }
        }
        consImageTopMargin.constant = consDayTopMargin.constant / 2
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if velocity < 0 {
            closeHeaderView(scrollView: scrollView)
        }
//        else {
//            openHeaderView(scrollView: scrollView)
//        }
        else if consHiddenNaviBar.constant < 0 && velocity == 0 {
            openHeaderView(scrollView: scrollView)
        }
        else if consHiddenNaviBar.constant >= 0 && velocity == 0 {
            closeHeaderView(scrollView: scrollView)
        }
    }

    var topAnimationFlag: Bool = false
    
    func closeHeaderView(scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
        UIView.animate(withDuration: 0.2, animations: {
            self.topAnimationFlag = true
            self.consHiddenNaviBar.constant = 95
            self.consDayTopMargin.constant = -115
            self.consImageTopMargin.constant = self.consDayTopMargin.constant / 2
            self.barStyle = .lightContent
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.topAnimationFlag = false
            
        }
    }
    
    func openHeaderView(scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
        UIView.animate(withDuration: 0.2, animations: {
            self.topAnimationFlag = true
            self.consHiddenNaviBar.constant = -20
            self.consDayTopMargin.constant = 0
            self.consImageTopMargin.constant = self.consDayTopMargin.constant / 2
            self.barStyle = .darkContent
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.topAnimationFlag = false
        }
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath) as! MangaCell
        
        cell.thumbnailImageView?.image = imageList[indexPath.row]
        
        if indexPath.row % 3 == 1 {
            cell.titleLabel.text = titleList[0]
            cell.writerLabel.text = writerList[0]
        }
        else if indexPath.row % 3 == 2 {
            cell.titleLabel.text = titleList[1]
            cell.writerLabel.text = writerList[1]
        }
        else if indexPath.row % 3 == 0 {
            cell.titleLabel.text = titleList[2]
            cell.writerLabel.text = writerList[2]
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight: CGFloat = yourWidth + 58
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
