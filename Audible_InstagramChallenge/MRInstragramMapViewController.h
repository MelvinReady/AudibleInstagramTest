//
//  MRInstragramMapViewController.h
//  Audible_InstagramChallenge
//
//  Created by Melvin Ready on 7/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRInstagramAnnotation.h"

@interface MRInstragramMapViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic, strong) NSMutableArray *arrOfInstagram;

@end
