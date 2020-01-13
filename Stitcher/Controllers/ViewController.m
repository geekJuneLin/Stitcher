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

@property (nonatomic, strong) UIImageView *centerImg;

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
    _centerImg = [[UIImageView alloc] init];
    _centerImg.image = [UIImage imageNamed: @"sloth2"];
    _centerImg.layer.masksToBounds = true;
    _centerImg.layer.cornerRadius = 10;
    _centerImg.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:_centerImg];
    
//    [centerImg anchors:self.view.centerXAnchor centerXConstant:0 withCenterY:self.view.centerYAnchor centerYConstant:0 withTop:nil topConstant:0 withBottom:nil bottomConstant:0 withLeft:nil leftConstant:0 withRight:nil rightConstant: 0];
    [_centerImg.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8].active = true;
    [_centerImg.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.25].active = true;
    [_centerImg.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_centerImg.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
}


// MARK: - other functions
-(void)checkIfThereAreScreenshots{
    NSLog(@"checking if there are screenshots exsit in albumn");
    
    // specify the certain start and end date to be searched
    NSDate *startDate = [NSDate.now dateByAddingTimeInterval:-(60 * 60 * 24)];
    NSDate *endDate = NSDate.now;
    
    // specify the search options for searching
    PHFetchOptions *orderedOption = [[PHFetchOptions alloc] init];
    orderedOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    orderedOption.predicate = [NSPredicate predicateWithFormat:@"creationDate > %@ AND creationDate < %@" argumentArray:[NSArray arrayWithObjects:startDate, endDate, nil]];
    
    // fetch the preset searching options results
    PHFetchResult *results = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:orderedOption];
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Type: %lu", (unsigned long)[obj mediaSubtypes]);
        
        // check if the image is screenshot
        if([obj mediaSubtypes] == 4){
            [self convertPHAssetToImage: results[0]];
        }
    }];
    
    // release the variables
    orderedOption = nil;
    startDate = nil;
    endDate = nil;
}

-(void)convertPHAssetToImage: (PHAsset *) asset{
    PHImageRequestOptions *imageOptions = PHImageRequestOptions.new;
    [imageOptions setSynchronous:true];
    [imageOptions setVersion: PHImageRequestOptionsVersionCurrent];
    [imageOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeOpportunistic];
    [imageOptions setResizeMode:PHImageRequestOptionsResizeModeNone];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset
                            targetSize:PHImageManagerMaximumSize
                           contentMode:PHImageContentModeDefault
                               options:imageOptions
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            self->_centerImg.image = result;
                        }];
    
    imageOptions = nil;
    imageManager = nil;
}


// MARK: - selector functions
-(void)handleLeftBtnClick{
    NSLog(@"Left button pressed...");
}

-(void)handleRightBtnClick{
    NSLog(@"Right button pressed...");
}

@end
