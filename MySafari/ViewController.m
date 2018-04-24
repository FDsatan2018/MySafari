//
//  ViewController.m
//  MySafari
//
//  Created by FDsatan on 2018/4/22.
//  Copyright © 2018年 FDsatan. All rights reserved.
//

#import "ViewController.h"
#import "HistoryTableViewController.h"
#import "LikeTableViewController.h"

@interface ViewController () <UIWebViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    UIWebView *_webView;
    UITextField *_searchBar;
    UILabel *_titleLabel;
    BOOL _isUp;
    UISwipeGestureRecognizer *_upSwip;
    UISwipeGestureRecognizer *_downSwip;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //状态栏的高20 + 导航栏的高44 = 64
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _isUp = NO;
    //默认加载百度
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    //先设置网页title的相关数据
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    //初始化搜索框
    [self setSearchBar];
    //初始化上滑手势
    [self setUpSwip];
    //初始化下滑手势
    [self setDownSwip];
    //初始化工具栏
    [self setToolBar];
}

#pragma mark - 初始化搜索框
- (void)setSearchBar{
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 30)];
    _searchBar.borderStyle = UITextBorderStyleRoundedRect;
    _searchBar.placeholder = @"请输入网址...";
    //创建搜索按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setTitle:@"GO" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor blackColor];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(goToWeb) forControlEvents:UIControlEventTouchUpInside];
    _searchBar.rightView = button;
    _searchBar.rightViewMode = UITextFieldViewModeAlways;
    //将搜索栏添加到导航栏上
    self.navigationItem.titleView = _searchBar;
}
//网页调转
-(void)goToWeb{
    if (_searchBar.text.length > 0) {
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@",_searchBar.text]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }else{
        //假如用户发送了空的网址则提醒用户不能输入空的网址
        UIAlertController *alertCr = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"输入的网址不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return;
        }];
        [alertCr addAction:action];
        [self presentViewController:alertCr animated:YES completion:nil];
        return;
    }
}

#pragma mark - 初始化上滑手势
-(void)setUpSwip{
    //创建手势
    _upSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwip)];
    _upSwip.direction = UISwipeGestureRecognizerDirectionUp;
    _upSwip.delegate = self;
    //添加手势
    [_webView addGestureRecognizer:_upSwip];
}

-(void)upSwip{
    if (_isUp) {
        return;    //假如用户在此之前已经处于向上刷的手势，则不需要再做一些控件的隐藏动作
    }else{
        self.navigationItem.titleView = nil;
//        _webView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40);
        //添加UIView过渡动画
        [UIView animateWithDuration:0.3 animations:^{
            //iOS11开始不能修改系统导航栏的高度了。
//            self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40); //导航栏的高变为20，刚好放titleLabel就行，减掉的24给webView
            [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:7 forBarMetrics:UIBarMetricsDefault];
        } completion:^(BOOL finished) {
            self.navigationItem.titleView = _titleLabel;
        }];
        [self.navigationController setToolbarHidden:YES animated:YES];
        _isUp = YES;
    }
}

#pragma mark - 初始化下滑手势
-(void)setDownSwip{
    //创建手势
    _downSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwip)];
    _downSwip.direction = UISwipeGestureRecognizerDirectionDown;
    _downSwip.delegate = self;
    //添加手势
    [_webView addGestureRecognizer:_downSwip];
}

-(void)downSwip{
    [self.navigationController setToolbarHidden:NO animated:YES];
    if (_webView.scrollView.contentOffset.y == 0 && _isUp) {  //此时滑动到了webView最顶处
        self.navigationItem.titleView = nil;
//        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        [UIView animateWithDuration:0.3 animations:^{
//            self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
            [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
        } completion:^(BOOL finished) {
            self.navigationItem.titleView = _searchBar;
        }];
        _isUp = NO;
    }
}

#pragma mark - 初始化工具栏
-(void)setToolBar{
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *itemHistory = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(goHistory)];
    UIBarButtonItem *itemLike = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(goLike)];
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    UIBarButtonItem *itemForward = [[UIBarButtonItem alloc] initWithTitle:@"forward" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    UIBarButtonItem *emptyItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *emptyItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *emptyItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[itemHistory,emptyItem1,itemLike,emptyItem2,itemBack,emptyItem3,itemForward];
}

-(void)goHistory{
    HistoryTableViewController *historyVC = [[HistoryTableViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}
-(void)goLike{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择您要进行的操作" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"添加收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:@"Like"];
        if (!array) {
            array = [[NSArray alloc] init];
        }
        NSMutableArray *mulArray = [[NSMutableArray alloc] initWithArray:array];
        [[NSUserDefaults standardUserDefaults] setObject:mulArray forKey:@"Like"];
        [[NSUserDefaults standardUserDefaults] synchronize]; //将数据同步到沙盒中
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"查看收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LikeTableViewController *likeVC = [[LikeTableViewController alloc] init];
        [self.navigationController pushViewController:likeVC animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)goBack{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}
-(void)goForward{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

#pragma mark - 解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer == _upSwip || gestureRecognizer == _downSwip) {
        return YES;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
