//
//  MRHashTagImagesCollectionViewController.m
//  Audible_InstagramChallenge
//
//  Created by Melvin Ready on 7/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import "MRInstagramImagesCollectionViewController.h"
#import "MRInstagramImageCell.h"

#import "InstagramKit.h"
#import "UIImageView+AFNetworking.h"

#import "MRInstragramMapViewController.h"


@interface MRInstagramImagesCollectionViewController()

//Current '#' search string
@property(nonatomic, strong) NSString *searchString;

//Boolean for infinite scrolling protection
@property (nonatomic, assign) BOOL bGettingImages;

//Array for instagram data, and variable for pagination control
@property (nonatomic, strong) NSMutableArray* arrayInstagramMedia;
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;

//Gradients for embellishment of view while scrolling
@property (nonatomic, strong) CAGradientLayer *unoGradientLayer;
@property (nonatomic, strong) CAGradientLayer *dosGradientLayer;

//Original Bounds
@property (nonatomic, assign) CGRect mainBounds;

@end

@implementation MRInstagramImagesCollectionViewController 

#pragma mark - Object Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set initial search string
    self.searchString = @"selfie";
    
    //Create search textfield and modify properties as desired
    UITextField *searchSelfie = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/2, 40)];
    searchSelfie.delegate = self;
    searchSelfie.placeholder = @"'#' image searcher";
    searchSelfie.textAlignment = NSTextAlignmentCenter;
    searchSelfie.text = self.searchString;
    searchSelfie.backgroundColor = [UIColor colorWithRed:0.0/255
                                                   green:255.0/255
                                                    blue:0.0/255
                                                   alpha:.1];
    
    //Set out textfield to the navigation bars center
    self.navigationItem.titleView = searchSelfie;
    
    //Set main bounds value.
    self.mainBounds = [[UIScreen mainScreen] bounds];
    
    //Set up gradient layer properties
    self.dosGradientLayer = [CAGradientLayer layer];
    self.dosGradientLayer.frame = self.mainBounds;
    self.unoGradientLayer = [CAGradientLayer layer];
    self.unoGradientLayer.frame = self.mainBounds;
    self.unoGradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [self.view.layer insertSublayer:self.unoGradientLayer atIndex:0];
    
    //Call to set initial layer
    [self beautification];
    
    //Initialize our data holding array, and get initial images.
    self.arrayInstagramMedia = [NSMutableArray new];
    [self acquireMoreImages];
    
    //Generate orientation chagne notifications and listen for thme to fix our gradients frames
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fixGradientLayerFrames)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Embellishing the Scrolling

-(void)beautification {
    
    //Get coefficients to use for our colors
    NSUInteger offSet = (NSUInteger)self.collectionView.contentOffset.y;
    CGFloat regCoefficient = offSet % 255;
    CGFloat invertedCoefficient = -(offSet %255);
    
    //Get slightly fluctuating colors based on coefficients
    UIColor *red = [UIColor colorWithRed:255.0/255
                                   green: regCoefficient/255
                                    blue:invertedCoefficient/255
                                   alpha:1.0];
    
    UIColor *green = [UIColor colorWithRed:invertedCoefficient/255
                                     green: 255.0/255
                                      blue:regCoefficient/255
                                     alpha:1.0];
    
    UIColor *blue = [UIColor colorWithRed:regCoefficient/255
                                    green: invertedCoefficient/255
                                     blue:255.0/255
                                    alpha:1.0];
    
    //Set up the new gradient layer, and apply to view
    self.dosGradientLayer.colors = [NSArray arrayWithObjects:(id)[red CGColor],(id)[green CGColor], (id)[blue CGColor], nil];
    [self.view.layer replaceSublayer:self.unoGradientLayer
                                with:self.dosGradientLayer];
    
    //Update old layer to new layer
    self.unoGradientLayer = self.dosGradientLayer;
}

-(void)fixGradientLayerFrames {
    //Get the current orientation that we are shifting to
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    
    //Modify our gradients layers based on our current orientation
    if( UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.dosGradientLayer.frame = CGRectMake(0, 0, self.mainBounds.size.height, [[UIScreen mainScreen] bounds].size.width);
        self.unoGradientLayer.frame = CGRectMake(0, 0, self.mainBounds.size.height, [[UIScreen mainScreen] bounds].size.width);
        
    }
    else if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) && interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown){
        self.dosGradientLayer.frame = CGRectMake(0, 0, self.mainBounds.size.width, self.mainBounds.size.height);
        self.unoGradientLayer.frame = CGRectMake(0, 0, self.mainBounds.size.width, self.mainBounds.size.height);
    }
    
    //Make our view pretty again
    [self beautification];
}

#pragma mark - Query more images
- (void)acquireMoreImages
{
    [[InstagramEngine sharedEngine] getMediaWithTagName:self.searchString count:30 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        
        // Save paging info, add data to data array, and reload our collectionview.
        self.currentPaginationInfo = paginationInfo;
        [self.arrayInstagramMedia addObjectsFromArray:media];
        [self.collectionView reloadData];
        
        //Toggle buffering boolean, and stop activity indicator of device.
        self.bGettingImages = false;
        
    } failure:^(NSError *error) {
        //Toggle buffering boolean, and stop activity indicator of device.
        self.bGettingImages = false;
    }];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayInstagramMedia.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MRInstagramImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier"
                                                                           forIndexPath:indexPath];
    
    __weak MRInstagramImageCell *safeCellReference = cell;
    
    // Set placeholders, and animation to start as well as setting data to work with.
    [cell.instagramImages setImage:[UIImage imageNamed:@"placeHolder"]];
    [cell.loadingIndicator startAnimating];
    InstagramMedia *instagramData = self.arrayInstagramMedia[indexPath.row];
    
    if((indexPath.item % 3) == 0)
    {
        [cell.instagramImages setImageWithURLRequest:[NSURLRequest requestWithURL:instagramData.standardResolutionImageURL]
                                    placeholderImage:nil
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            //Stop animation and set proper image.
            [safeCellReference.loadingIndicator stopAnimating];
            [safeCellReference.instagramImages setImage:image];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            //Stop animation.
            [safeCellReference.loadingIndicator stopAnimating];
        }];
    }
    else
    {
        [cell.instagramImages setImageWithURLRequest:[NSURLRequest requestWithURL:instagramData.thumbnailURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            //Stop animation and set proper image.
            [safeCellReference.loadingIndicator stopAnimating];
            [safeCellReference.instagramImages setImage:image];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            //Stop animation.
            [safeCellReference.loadingIndicator stopAnimating];
        }];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MRInstragramMapViewController *bsMV = [MRInstragramMapViewController new];
    bsMV.arrOfInstagram = self.arrayInstagramMedia;
    [self.navigationController pushViewController:bsMV animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //Distance to edge of collectionview.
    return UIEdgeInsetsMake(10.0f, 40.0f, 10.0f, 40.0f);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Set our cells sizes according to constants.
    if((indexPath.item % 3) == 0)
        return CGSizeMake(150.0, 150.0);
    else
        return CGSizeMake(75.0, 75.0);
}

#pragma mark - Scrollview Delegates

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if( self.collectionView.contentOffset.y >= self.collectionView.contentSize.height - (self.collectionView.frame.size.height)  )
    {
        //Get more images
        [self acquireMoreImages];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if( self.collectionView.contentOffset.y >= self.collectionView.contentSize.height - (self.collectionView.frame.size.height * 3) && !self.bGettingImages ) {
        //Toggle buffering boolean and get more images
        self.bGettingImages = true;
        [self acquireMoreImages];
    }
    //Call to slightly alter gradient of view whenever scrolling
    [self beautification];
}


#pragma mark - Textfield delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //Clear our textfield
    textField.text = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if( textField.text.length > 0 )
    {
        //Set new string, empty array, and ask for images
        self.searchString = textField.text;
        self.arrayInstagramMedia = [NSMutableArray new];
        [self.collectionView reloadData];
        [self acquireMoreImages];
    }
    else{
        //Place back old string
        textField.text = self.searchString;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //Lower our keyboard
    [textField resignFirstResponder];
    return  YES;
}

@end
