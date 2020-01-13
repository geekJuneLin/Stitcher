//
//  ViewController.m
//  Stitcher
//
//  Created by Junyu Lin on 13/01/20.
//  Copyright © 2020 Junyu Lin. All rights reserved.
//

#import "ViewController.h"
#import "UIView+UIView_Autolayout.h"

@import Photos;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self checkIfThereAreScreenshots];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpNavigationController];
    [self setUpViews];
}

-(void)setUpNavigationController{
    // set up navigation title
    self.navigationController.navigationBar.topItem.title = @"Stitcher";
    
    // left button set up
    UIImage *leftImg = [UIImage systemImageNamed:@"line.horizontal.3"];
    [leftImg imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage: leftImg style:UIBarButtonItemStylePlain target:self action:@selector(handleLeftBtnClick)];
    leftBtn.tintColor = UIColor.blackColor;
    self.navigationController.navigationBar.topItem.leftBarButtonItem = leftBtn;
    
    
    // right button set up
    UIImage *rightImg = [UIImage systemImageNamed: @"trash"];
    [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(handleRightBtnClick)];
    rightBtn.tintColor = UIColor.blackColor;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = rightBtn;
    
    // set the navigationBar to be transparent
    [self.navigationController.navigationBar setTranslucent:true];
    [self.navigationController.navigationBar setShadowImage: UIImage.new];
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics: UIBarMetricsDefault];
}

-(void)setUpViews{
    // setup background color
    self.view.backgroundColor = [UIColor colorWithRed:0.22 green:0.5 blue:0.72 alpha:1];
    
    // set up center UIImageView
    UIImageView *centerImg = [[UIImageView alloc] init];
    centerImg.image = [UIImage imageNamed: @"sloth2"];
    centerImg.layer.masksToBounds = true;
    centerImg.layer.cornerRadius = 10;
    centerImg.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:centerImg];
    
//    [centerImg anchors:self.view.centerXAnchor centerXConstant:0 withCenterY:self.view.centerYAnchor centerYConstant:0 withTop:nil topConstant:0 withBottom:nil bottomConstant:0 withLeft:nil leftConstant:0 withRight:nil rightConstant: 0];
    [centerImg.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8].active = true;
    [centerImg.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.25].active = true;
    [centerImg.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [centerImg.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
}


// MARK: - other functions
-(void)checkIfThereAreScreenshots{
    NSLog(@"checking if there are screenshots exsit in albumn");
    
    PHFetchOptions *oderedOption = [[PHFetchOptions alloc] init];
    oderedOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *results = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:oderedOption];
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Asset: %@", obj);
    }];
}


// MARK: - selector functions
-(void)handleLeftBtnClick{
    NSLog(@"Left button pressed...");
}

-(void)handleRightBtnClick{
    NSLog(@"Right button pressed...");
}

@end
