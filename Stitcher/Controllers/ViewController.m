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

@property (nonatomic, strong) UIScrollView *centerImg;

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
    _centerImg = [[UIScrollView alloc] init];
    _centerImg.layer.masksToBounds = true;
    _centerImg.layer.cornerRadius = 10;
    _centerImg.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:_centerImg];
    
    [_centerImg.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = true;
    [_centerImg.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = true;
    [_centerImg.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [_centerImg.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
}


// MARK: - other functions
-(void)checkIfThereAreScreenshots{
    NSLog(@"checking if there are screenshots exsit in albumn");
    
    __block NSMutableArray *screenshots = NSMutableArray.new;
    
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
            [screenshots addObject:[self convertPHAssetToImage: obj]];
        }
    }];
    
    // check if images are overlapped
    for(int i=0; i<screenshots.count; i++){
        if(i < (screenshots.count - 1)){
            if([self checkIntersection:screenshots[i] withImage:screenshots[i + 1]]){
                NSLog(@"Images are intersected");
            }else{
                NSLog(@"There are some images not intersected");
            }
        }
    }
    
    // merge all the screenshots and save to photo library
    [self mergeImages: screenshots];
    NSLog(@"There are %lu screenshots", screenshots.count);
    
    // release the variables
    orderedOption = nil;
    startDate = nil;
    endDate = nil;
}

/// convert PHAsset to UIImage
/// @param asset The PHAsset need to be converted
-(UIImage *)convertPHAssetToImage: (PHAsset *) asset{
    __block UIImage *convertedImage;
    
    PHImageRequestOptions *imageOptions = PHImageRequestOptions.new;
    [imageOptions setSynchronous:true];
    [imageOptions setVersion: PHImageRequestOptionsVersionOriginal];
    [imageOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [imageOptions setResizeMode:PHImageRequestOptionsResizeModeExact];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset
                            targetSize: CGSizeMake(UIScreen.mainScreen.bounds.size.width * 0.8, UIScreen.mainScreen.bounds.size.height * 0.8)
                           contentMode:PHImageContentModeAspectFit
                               options:imageOptions
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            convertedImage = result;
                        }];
    
    imageOptions = nil;
    imageManager = nil;
    return convertedImage;
}


/// check if those two images are intersected
/// @param image1 the first image
/// @param image2 the second image
-(BOOL)checkIntersection: (UIImage *) image1 withImage: (UIImage *) image2{
    return CGRectIntersectsRect(image1.accessibilityFrame, image2.accessibilityFrame);
}

/// loop through all the images in the array, and stitch them vertically
/// once the process is done then will save the stitched image to photo library
/// @param images the array of images need to be stitched
-(void)mergeImages: (NSArray *) images{
    UIImageView *mergedView = UIImageView.new;
    mergedView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height * images.count);
    
    CGSize size = CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height * images.count);
    UIGraphicsBeginImageContext(size);
    
    for (UIImage *image in images){
        [image drawInRect:CGRectMake(0, [images indexOfObject:image] * size.height / images.count, size.width, size.height / images.count)];
    }
    
    UIImage *mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    mergedView.image = mergedImage;
    [_centerImg addSubview:mergedView];
    _centerImg.contentSize = mergedView.bounds.size;
    
    [self saveImageToLibrary:mergedImage];
}

/// save the image to photo library
/// @param image the image need to be saved
-(void)saveImageToLibrary: (UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

// MARK: - selector functions
-(void)handleLeftBtnClick{
    NSLog(@"Left button pressed...");
}

-(void)handleRightBtnClick{
    NSLog(@"Right button pressed...");
}


// TODO: get the intersection of the images
-(void)getIntersection: (UIImage *) image1 withImage: (UIImage *) image2{
    UIImageView *v1 = UIImageView.new;
    [v1 setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
//    v1.frame = ;
    v1.image = image1;
    [self.view addSubview:v1];
    
    UIImageView *v2 = UIImageView.new;
    [v1 setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
//    v2.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    v2.image = image2;
    [self.view addSubview:v2];
    
    CGRect intersection = CGRectIntersection(v1.frame, v2.frame);
    if(!CGRectIsNull(intersection)){
        NSLog(@"intersection: %@", NSStringFromCGRect(intersection));
    }else{
        NSLog(@"No intersection found!");
    }
}

@end
