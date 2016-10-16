//
//  LQAPageContentView.swift
//  斗鱼直播
//
//  Created by Apple on 2016/10/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

protocol LQAPageContentViewDelegate:class {
    func pageContentViewScrollTo(sourceIndex:Int,targetIndex:Int,progress:CGFloat)
}

private let kCellReuseId:String = "kCellReuseId"

class LQAPageContentView: UIView {
    //存放子控制器的数组
    fileprivate var childVcs : [UIViewController] = [UIViewController]()
    
    fileprivate var parentVc : UIViewController = UIViewController()
    
    fileprivate var startOffsetX:CGFloat = 0;
    
    var delegate:LQAPageContentViewDelegate?
    
    // MARK 懒加载CollectionView
    fileprivate lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellReuseId)
        return collectionView
    }()
    
    
    init(frame: CGRect,childVcs:[UIViewController],parentVc:UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK 设置UI
extension LQAPageContentView {
    fileprivate func setUpUI(){
        addChildVc()
        addSubview(collectionView)
    }
    private func addChildVc() {
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
    }
}

//MARK UICollectionView DataSource
extension LQAPageContentView:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseId, for: indexPath)
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}
//MARK UICollectionView Delegate
extension LQAPageContentView:UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 定义要获取的内容
        var sourceIndex = 0
        var targetIndex = 0
        var progress:CGFloat = 0
        
        // 获取进度
        let offsetX = scrollView.contentOffset.x
        let ratio = offsetX/scrollView.bounds.width
        progress = ratio - floor(ratio)
        
        //判断滑动方向
        if offsetX > startOffsetX { // 左滑
            sourceIndex = Int(offsetX/scrollView.bounds.width)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            if offsetX - startOffsetX == scrollView.bounds.width {
                progress = 1.0
                targetIndex = sourceIndex
            }
            
        }else {// 右滑
            targetIndex = Int(offsetX/scrollView.bounds.width)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            progress = 1 - progress
        }
        
        delegate?.pageContentViewScrollTo(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }

}

//MARK 对外暴露的方法
extension LQAPageContentView {
    func setCollectionViewContentWith(index:Int) {
        let offset = CGPoint(x: CGFloat(index) * collectionView.frame.width, y: 0)
        collectionView.setContentOffset(offset, animated: false)
        
        
    }


}




