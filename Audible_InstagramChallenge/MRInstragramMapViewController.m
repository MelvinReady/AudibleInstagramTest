//
//  MRInstragramMapViewController.m
//  Audible_InstagramChallenge
//
//  Created by Melvin Ready on 7/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//


#import "MRInstragramMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "InstagramKit.h"

#import "UIImageView+AFNetworking.h"

@interface MRInstragramMapViewController ()

@end

MKMapView *theMap;

@implementation MRInstragramMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Create our map, set its delegate and add to the view
    theMap = [[MKMapView alloc] initWithFrame:self.view.bounds];
    theMap.delegate = self;
    [self.view addSubview:theMap];
    
    [self addAnnotations];
}

-(void)addAnnotations{
    for( InstagramMedia *instagramData in self.arrOfInstagram){
        if( instagramData.location.latitude != 0 && instagramData.location.longitude != 0  ){
            //Make a simple annotation and add it to the map
            MRInstagramAnnotation *bs = [[MRInstagramAnnotation alloc] initWithLocation:instagramData.location
                                                                              withTitle:instagramData.user.username
                                                                            andSubtitle:instagramData.caption.text];
            [theMap addAnnotation:bs];
        }
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //Create and customize pin to show on map as desired
    MKPinAnnotationView *userImagePin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:@"you"];
    
    [userImagePin setCanShowCallout:YES];
    userImagePin.enabled = YES;
    
    InstagramMedia *instagramData = self.arrOfInstagram[[mapView.annotations indexOfObject:annotation]];
    
    UIImageView *userImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [userImageV setImageWithURL:instagramData.standardResolutionImageURL placeholderImage:nil];
    
    [userImagePin setContentMode:UIViewContentModeScaleToFill];
    [userImagePin setImage:userImageV.image];
    [userImagePin setFrame:CGRectMake(0, 0, 30, 30)];
    
    return userImagePin;
}

@end
