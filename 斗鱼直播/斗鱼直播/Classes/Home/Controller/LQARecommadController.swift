//
//  LQARecommadController.swift
//  斗鱼直播
//
//  Created by Apple on 2016/10/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

private let kItemMargin:CGFloat = 10
private let kNormalItemW:CGFloat = (kScreenW - 3 * kItemMargin) * 0.5
private let kNormalItemH:CGFloat = kNormalItemW * (0.75)
private let kNormalCellID = "kNormalCellID"
private let kCollectionViewHeaderID = "kCollectionViewHeaderID"
private let kPrettyCellID = "kPrettyCellID"
private let kPrettyItemH:CGFloat = kNormalItemW * 4 / CGFloat(3)
class LQARecommadController: UIViewController {
    
    //MARK:懒加载UICollectionView
    fileprivate lazy var collectionView:UICollectionView = {[weak self] in
        let flowLayout  = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.headerReferenceSize = CGSize(width: kScreenW, height: 50)
        let collectionView = UICollectionView(frame:self!.view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
         collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.register(UINib(nibName: "LQAHomeSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kCollectionViewHeaderID)
        collectionView.register(UINib(nibName: "LQANormalCell", bundle: nil)
            , forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "LQAPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        return collectionView
    }()
    
    //MARK 系统生命周期回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
      
      
    }
}

//MARK: 设置UI界面
extension LQARecommadController {
    fileprivate func setUpUI() {
        view.addSubview(collectionView)
    }
}

//MARK: UICollectionView 的数据源
extension LQARecommadController:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kCollectionViewHeaderID, for: indexPath)
        return header
    }

}

extension LQARecommadController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }
            return CGSize(width: kNormalItemW, height: kNormalItemH)
      
    }


}



