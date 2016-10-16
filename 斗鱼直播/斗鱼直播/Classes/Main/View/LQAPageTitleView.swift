//
//  LQAPageTitleView.swift
//  斗鱼直播
//
//  Created by Apple on 2016/10/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit


protocol LQAPageTitleViewDelegate: class {
    func titleLabelDidSelected(pageTitleView:LQAPageTitleView ,selectedIndex index:Int)

}

private let kScrollLineH:CGFloat = 2
private let kTitleMargin:CGFloat = 20
private let kNormalRGB:(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectRGB:(CGFloat,CGFloat,CGFloat) = (255,128,0)
private let kDeltaRGB = (kSelectRGB.0 - kNormalRGB.0,kSelectRGB.1 - kNormalRGB.1,kSelectRGB.2 - kNormalRGB.2)
private let kNormalTitleColor = UIColor(r: 85, g: 85, b: 85)
private let kSelectTitleColor = UIColor(r: 255, g: 128, b: 0)
class LQAPageTitleView: UIView {
    // MARK 定义一些属性
    fileprivate  var titles:[String]
    var isScrollEnabled:Bool = false
    fileprivate var currentIndex = 0
    
    var delegate:LQAPageTitleViewDelegate?
    
    
    fileprivate lazy var titleLabels:[UILabel] = [UILabel] ()
    // MARK 懒加载一些控件
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame:self.bounds)
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate lazy var scrollViewLine:UIView = {
        let scrollViewLine = UIView()
        scrollViewLine.backgroundColor = UIColor.orange
        return scrollViewLine
    }()
    
    init(frame: CGRect ,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 设置UI部分
extension LQAPageTitleView {
    fileprivate func setUpUI () {
        addSubview(scrollView)
        setUpTitleLabels()
        setUpScrollLineAndBottomLine()
    }
    // 设置TitleLabels
    private func setUpTitleLabels() {
        var titleLabelsW:CGFloat = 0
        let titleLabelsH:CGFloat = bounds.height - kScrollLineH
        let titleLabesY:CGFloat = 0
        var titleLabelsX :CGFloat = 0
       
        for (index,title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            titleLabels.append(titleLabel)

            if isScrollEnabled == false {
                titleLabelsW = bounds.width/CGFloat(titles.count)
                titleLabelsX = CGFloat(index) * titleLabelsW
            }else {
                let size = (title as NSString).boundingRect(with:CGSize(width:CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleLabel.font], context: nil)
                    titleLabelsW = size.width
                if index != 0 {
                    titleLabelsX = titleLabels[index - 1].frame.maxX + kTitleMargin
                }
            }
            titleLabel.textAlignment = .center
            titleLabel.textColor = kNormalTitleColor
            titleLabel.tag = index
            titleLabel.frame = CGRect(x:titleLabelsX, y: titleLabesY, width: titleLabelsW, height: titleLabelsH)
            scrollView.addSubview(titleLabel)
            titleLabel.isUserInteractionEnabled = true
            let tapG = UITapGestureRecognizer.init(target: self, action:#selector(titleLabelDidTap))
            titleLabel.addGestureRecognizer(tapG)
        }
    }
    
    private func setUpScrollLineAndBottomLine (){
        let bottomView = UIView(frame: CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5))
        bottomView.backgroundColor = UIColor.gray
        addSubview(bottomView)
         addSubview(scrollViewLine)
        guard let firstlabel = titleLabels.first else{
            return;
        }
        scrollViewLine.frame = CGRect(x:firstlabel.frame.origin.x, y:frame.size.height - kScrollLineH, width: firstlabel.frame.size.width, height: kScrollLineH)
        firstlabel.textColor = kSelectTitleColor
    }
    
   @objc private func titleLabelDidTap(tap:UITapGestureRecognizer) {
        let tapLabel = tap.view as! UILabel
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = kNormalTitleColor
        tapLabel.textColor = kSelectTitleColor
        currentIndex = tapLabel.tag
        UIView.animate(withDuration: 0.3) { 
            self.scrollViewLine.frame.origin.x  = CGFloat(self.currentIndex) * tapLabel.frame.width
    }
        delegate?.titleLabelDidSelected(pageTitleView: self, selectedIndex: currentIndex)
}
    
}

//MARK:对外暴露的方法
extension LQAPageTitleView {
    func setCurrentTitle(sourceIndex:Int,targetIndex:Int,progress:CGFloat) {
        //取出两个Label
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //移动ScrollLine
        let moveMargin = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        scrollViewLine.frame.origin.x = sourceLabel.frame.origin.x + moveMargin * progress
        
        //颜色渐变
        sourceLabel.textColor = UIColor(red: (kSelectRGB.0 - kDeltaRGB.0 * progress)/255.0, green: (kSelectRGB.1 - kDeltaRGB.1 * progress)/255.0, blue: (kSelectRGB.2 - kDeltaRGB.2 * progress)/255.0, alpha: 1)
        targetLabel.textColor = UIColor(red: (kNormalRGB.0 + kDeltaRGB.0 * progress)/255.0, green: (kNormalRGB.1 + kDeltaRGB.1 * progress)/255.0, blue:(kNormalRGB.2 + kDeltaRGB.2 * progress)/255.0, alpha: 1)
        
        
    }


}

