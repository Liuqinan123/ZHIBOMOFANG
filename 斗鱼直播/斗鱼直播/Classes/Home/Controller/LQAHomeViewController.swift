//
//  LQAHomeViewController.swift
//  斗鱼直播
//
//  Created by Apple on 2016/10/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

private let kPageTitleH:CGFloat = 40

//MARK 基本定义
class LQAHomeViewController: UIViewController {
    
    //MARK 懒加载PageTitleView
    fileprivate lazy var pageTitleView:LQAPageTitleView = {
        let pageTitleView = LQAPageTitleView(frame:CGRect(x: 0, y:kStatusBarH+kNavigationBarH , width:kScreenW , height: kPageTitleH) , titles: ["推荐","游戏","娱乐","趣玩"])
        pageTitleView.isScrollEnabled = false
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    fileprivate lazy var pageContentView:LQAPageContentView = {
        var childVcs:[UIViewController] = [UIViewController]();
        childVcs.append(LQARecommadController())
        for  _ in 0...2 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red:CGFloat (CGFloat(arc4random_uniform(255))/255.0), green: CGFloat (CGFloat(arc4random_uniform(255))/255.0), blue: CGFloat (CGFloat(arc4random_uniform(255))/255.0), alpha: 1)
            childVcs.append(vc)
        }
        let pageContentView = LQAPageContentView(frame:CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kPageTitleH, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH - kPageTitleH - kTabBarH), childVcs: childVcs, parentVc: self)
        pageContentView.delegate = self;
        return pageContentView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        // MARK 去掉自动加的约束
        automaticallyAdjustsScrollViewInsets = false
        setUpUI()
    }
}
//MARK: 设置UI界面呢
extension LQAHomeViewController {
    fileprivate func setUpUI() {
        setUpNavigationBar()
    }
    // 设置导航栏
    private func setUpNavigationBar (){
        let size = CGSize(width: 40, height: 40)
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "homeLogoIcon")
        let scan = UIBarButtonItem(imageName: "scanIcon", highlitedImage: "scanIconHL", size: size)
        let his = UIBarButtonItem(imageName: "viewHistoryIcon", highlitedImage: "viewHistoryIconHL", size: size)
        let search = UIBarButtonItem(imageName: "searchBtnIcon", highlitedImage: "searchBtnIconHL", size: size);
        navigationItem.rightBarButtonItems = [search,scan,his]
    }
    
}

//MARK: PageTitleView 的代理
extension LQAHomeViewController:LQAPageTitleViewDelegate {
    func titleLabelDidSelected(pageTitleView: LQAPageTitleView, selectedIndex index: Int) {
        pageContentView.setCollectionViewContentWith(index: index)
    }


}

//MARK: PageContentView 的代理
extension LQAHomeViewController:LQAPageContentViewDelegate {
    func pageContentViewScrollTo(sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        pageTitleView.setCurrentTitle(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }

}
