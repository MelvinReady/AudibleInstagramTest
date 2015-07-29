//
//  MRInstagramAnnotation.h
//  Audible_InstagramChallenge
//
//  Created by Melvin Ready on 7/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MRInstagramAnnotation : NSObject<MKAnnotation>

-(instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate withTitle:(NSString*)title andSubtitle:(NSString*)subtitle;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
