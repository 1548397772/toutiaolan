//
//  ViewController.m
//  canimanid e
//
//  Created by yuanhc on 2017/8/14.
//  Copyright © 2017年 萤火照星空. All rights reserved.
//


// 颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define myFont 14
// 屏幕尺寸
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "MyViewController.h"
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerViewContent;
@property(strong,nonatomic)NSArray *titleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollerViewContent.pagingEnabled = YES;
    self.scrollViewTitle.showsHorizontalScrollIndicator = NO;
    self.scrollViewTitle.showsVerticalScrollIndicator = NO;
    CGFloat x = 20;
    for (int i = 0; i < self.titleArray.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:myFont];
        NSString *title = self.titleArray[i];
        CGFloat labelWidth =  [title boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:myFont]} context:nil].size.width;
        label.frame = CGRectMake(x, 0, labelWidth, 44);
        label.tag = i;
        x = x + labelWidth + 20;
        label.text = title;
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor purpleColor];
        UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        [label addGestureRecognizer:reg];
        if (i == 0) {
            label.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
        [self.scrollViewTitle addSubview:label];
    }
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = [NSString stringWithFormat:@"%d%d%d",i,i,i];
        [self addControllers:title];
    }
    self.scrollViewTitle.contentSize = CGSizeMake(x, 0);
    self.scrollerViewContent.contentSize = CGSizeMake(self.titleArray.count * ScreenW, 0);
    //出现第一个
    [self scrollViewDidEndScrollingAnimation:self.scrollerViewContent];
    
}

- (void)tapLabel:(UITapGestureRecognizer *)reg
{
    NSInteger index = reg.view.tag;
    CGFloat x = index * ScreenW;
    CGPoint offset = self.scrollerViewContent.contentOffset;
    offset.x = x;
    [self.scrollerViewContent setContentOffset:offset animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    NSLog(@"减速");
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    UILabel *label = self.scrollViewTitle.subviews[index];
    CGFloat titleOffsetX = label.center.x - ScreenW / 2;
    if (titleOffsetX < 0) {
        titleOffsetX = 0;
    }
    //这是最右边的屏幕中的二分之一啊
    CGFloat maxTitleOffsetX = self.scrollViewTitle.contentSize.width - ScreenW;
    if (titleOffsetX > maxTitleOffsetX) {
        titleOffsetX = maxTitleOffsetX;
    }
    CGPoint offsetTitle = CGPointMake(titleOffsetX, 0);
    [self.scrollViewTitle setContentOffset:offsetTitle animated:YES];
    
    MyViewController *vc = self.childViewControllers[index];
    if ([vc isViewLoaded]) {
        return;
    }
    vc.view.frame = CGRectMake(index * ScreenW, 0, ScreenW, self.scrollerViewContent.bounds.size.height);
    [self.scrollerViewContent addSubview:vc.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //小数  渐变
    CGFloat page  = scrollView.contentOffset.x / ScreenW;
    if (page < 1 || page > self.titleArray.count - 1   ) {
        return;
    }
    NSInteger leftTitleIndex = page;
    UILabel *leftLabel = self.scrollViewTitle.subviews[leftTitleIndex];
    
    NSUInteger rightTitleIndex = page + 1;
    UILabel *rightLabel;
    rightLabel = (rightTitleIndex == self.scrollViewTitle.subviews.count) ? nil : self.scrollViewTitle.subviews[rightTitleIndex];
    CGFloat rightScale = (page - leftTitleIndex)*0.4 + 1;
    CGFloat leftScale = (1 - (page - leftTitleIndex)) * 0.4 + 1;
    leftLabel.transform = CGAffineTransformMakeScale(leftScale, leftScale);
    rightLabel.transform = CGAffineTransformMakeScale(rightScale, rightScale);
    
}



- (void)addControllers:(NSString *)title
{
    
    MyViewController *vc = [[MyViewController alloc]init];
    vc.title = title;
    [self addChildViewController:vc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"一年你好狠",@"东方欲晓",@"东方超",@"下雪不能停",@"河工好2",@"东方105",@"照得睁不开",@"一缕蓝兔"];
    }
    return _titleArray;
}
@end
