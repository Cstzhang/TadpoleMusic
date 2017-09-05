//
//  SongSlideView.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/9/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SongSlideView.h"
#import "SongCardView.h"
#import "SongList+CoreDataClass.h"
@interface SongSlideView()
{
    NSMutableArray *_cardViewArray;//存储底部的cardView
    NSMutableArray *_slideCardViewArray;//存储滑动的cardView
    UIView *_bottomView;//用于显示叠加效果的底部视图
    UIScrollView *_mainScrollView;//用于滑动的交互视图
    
    NSInteger _index;//序列号
}
@end


@implementation SongSlideView


-(instancetype)initWithFrame:(CGRect)frame AndzMarginValue:(CGFloat)zMarginValue AndxMarginValue:(CGFloat)xMarginValue AndalphaValue:(CGFloat)alphaValue AndangleValue:(CGFloat)angleValue
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化
        self.cardDataArray = [[NSMutableArray alloc]init];
        _cardViewArray = [[NSMutableArray alloc]init];
        _slideCardViewArray = [[NSMutableArray alloc]init];
        self.zMarginValue = zMarginValue;
        self.xMarginValue = xMarginValue;
        self.alphaValue = alphaValue;
        self.angleValue = angleValue;
        
        //设置frame
        frame.origin = CGPointMake(0, 0);
        
        //初始化两个主要视图
        _bottomView = [[UIView alloc]initWithFrame:frame];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.layer.cornerRadius = 5.0;

        _mainScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.autoresizingMask = YES;
        _mainScrollView.clipsToBounds = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.layer.cornerRadius = 5.0;
        
        [self addSubview:_bottomView];
        [self addSubview:_mainScrollView];
        
        //设置叠加视图的透视投影(这一步很重要)
        CATransform3D sublayerTransform = CATransform3DIdentity;//单位矩阵
        sublayerTransform.m34 = -0.002;
        [_bottomView.layer setSublayerTransform:sublayerTransform];
    }
    
    return self;
}

//数据源填充
-(void)addCardDataWithArray:(NSArray *)array
{
    if (_cardDataArray.count == 0) {
        //初始化序列号（最大的序号）
        _index = array.count-1;
    }
    
    //_cardDataArray初始化
    [_cardDataArray addObjectsFromArray:array];
    
    if (_cardDataArray.count) {//如果数据不为空
        //加载叠加视图
        [self loadBottomView];
        //加载滚动视图 显示最后一张
        [self loadSlideCardView];
    }
}

#pragma mark- 加载最顶层的滚动视图
-(void)loadSlideCardView{
    CGSize viewSize = self.frame.size;
    CGFloat width = viewSize.width; //图宽
    //坐标
    CGPoint point = CGPointMake(0, (_cardDataArray.count-1)*viewSize.height);
    //实例化CardView
    SongCardView *card = [[SongCardView alloc]initWithFrame:CGRectMake(point.x, point.y, viewSize.width, viewSize.height-58)];
    //背景色
    card.backgroundColor = [UIColor whiteColor];
    //显示在最上层
    card.layer.masksToBounds = YES;
    //设置圆角
    card.layer.cornerRadius = 5.0;
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSelectCardViewAction)];
    [card addGestureRecognizer:tap];
    //添加到视图与数组中
    [_slideCardViewArray insertObject:card atIndex:0];
    [_mainScrollView addSubview:card];
    //设置滚动视图属性
    _mainScrollView.contentSize = _cardDataArray.count>1 ? CGSizeMake(width, viewSize.height*_cardDataArray.count):CGSizeMake(width, viewSize.height*_cardDataArray.count+1);
    _mainScrollView.contentOffset = CGPointMake(0, (_cardDataArray.count-1)* viewSize.height);
}

//显示在底部的View
-(void)loadBottomView{
    float height = self.frame.size.height;
    
    for(int i=0; i<(_cardDataArray.count<4?_cardDataArray.count:4); i++)
    {
        //设置CardView的坐标，z值和透明度(i=0 第一张的时候y偏移为0，慢慢向下偏移)
        CGPoint point = CGPointMake(0, -i*height/_xMarginValue);
        //z轴偏移 慢慢向左偏移
        float zPosition = -i*height/_zMarginValue;
        
        //实例化CardView -58 是为了脚部被上面的遮住
        SongCardView *card = [[SongCardView alloc]initWithFrame:CGRectMake(point.x, point.y, CardW,CardH)];
        //背景色
        card.backgroundColor = [UIColor whiteColor];
        //显示在最上面
        card.layer.masksToBounds = YES;
        //圆角
        card.layer.cornerRadius = 5.0;
        if (i<3) {//只显示3张，其余透明
            card.layer.zPosition = zPosition; // Z坐标
            card.alpha = 1;
        }
        else{
            card.layer.zPosition = -288; // Z坐标
            card.alpha = 0;//透明
        }
        //添加到视图与数组中
        if(i == 0){
            card.hidden = YES;
        }
        
        [_cardViewArray insertObject:card atIndex:0];
        [_bottomView addSubview:card];
    }
}

//通过协议，告诉控制器选择的卡片
-(void)showSelectCardViewAction
{
    if([self.delegate respondsToSelector:@selector(slideCardViewDidSlectIndex:)])
    {
        [self.delegate slideCardViewDidSlectIndex:_index];
    }
    
    NSLog(@"%ld",_index);
}

#pragma mark- UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView //滚动时处理
{
    CGFloat offset_y = scrollView.contentOffset.y;//scrollView所在位置
    CGFloat height = scrollView.frame.size.height;//高度
    CGFloat currentIndex = offset_y/height;//当前标签
    
    //得到索引 当前显示在最前的index 一般有5个 显示在最前面的是index=4
    _index = currentIndex>(int)currentIndex?(int)currentIndex+1:(int)currentIndex;
    
    if (_index>_cardDataArray.count-1) {
        _index = (int)_cardDataArray.count-1;
    }
    
    //调整滚动视图图片的角度
    SongCardView* scrollCardView = [_slideCardViewArray firstObject];
    if (scrollCardView.model==nil) {
        scrollCardView.model = _cardDataArray[_index];
    }
    //表示处于当前视图内
    if(scrollCardView.frame.origin.y<offset_y)
    {
        if(offset_y>_cardDataArray.count*height-height){
            NSLog(@"滑动下去了");
            scrollCardView.hidden = YES;
        }else{
            NSLog(@"滑动回来了1");
            scrollCardView.hidden = NO;
            scrollCardView.frame = CGRectMake(0, _index*height, CardW,CardH);
        }
    }
    else if(scrollCardView.frame.origin.y-height<offset_y&&offset_y<=scrollCardView.frame.origin.y)
    {
        NSLog(@"滑动途中");
        scrollCardView.hidden = NO;
    }
    else
    {
        NSLog(@"滑动回来了2");
        scrollCardView.frame = CGRectMake(0, _index*height, CardW,CardH);
    }
    
    NSInteger _select = _index-3>0?(_index-3):0;
    
    for (NSInteger i=_select; i<=_index; i++) {
        //调整滚动视图图片的角度
        float currOrigin_y = i * height; //当前图片的y坐标
        //调整叠加视图
        SongCardView* moveCardView = [_cardViewArray objectAtIndex:i-_select];
        if (moveCardView.model==nil) {
            moveCardView.model = _cardDataArray[i-_select];
        }
        
        NSLog(@"============== %ld",i-_select);
        float range_y = (currOrigin_y - offset_y)/(_xMarginValue) ;
        
        moveCardView.frame = CGRectMake(0, range_y, CardW,CardH);
        if(range_y >= 0) // 如果超过当前滑动视图便隐藏
            moveCardView.hidden = YES;
        else
        {
            moveCardView.hidden = NO;
        }
        
        //调整弹压视图的z值
        float range_z = -(offset_y-currOrigin_y)/_zMarginValue;
        
        moveCardView.layer.zPosition = range_z;
     
        
        //调整弹压视图的透明度
        float alpha = 1.f + (currOrigin_y-offset_y)/_alphaValue;
        
        if (currentIndex-2<=i && i<=currentIndex) {
            moveCardView.alpha = 1;
        }else if(currentIndex-2>i&&currentIndex-3<i){
            moveCardView.alpha = alpha;
        }
        else{
            moveCardView.alpha = 0;
        }
    }
    
    //代理滚动时回调函数
    if([self.delegate respondsToSelector:@selector(slideCardViewDidScrollAllPage:AndIndex:)])
        [self.delegate slideCardViewDidScrollAllPage:_cardDataArray.count-1 AndIndex:_index];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for(SongCardView* card in _slideCardViewArray)  //调整所有图片的z值
        card.layer.zPosition = 0;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView //滚动结束处理
{
    if([self.delegate respondsToSelector:@selector(slideCardViewDidEndScrollIndex:)])
    {
        [self.delegate slideCardViewDidEndScrollIndex:_index];
    }
    
    
    
}


@end
