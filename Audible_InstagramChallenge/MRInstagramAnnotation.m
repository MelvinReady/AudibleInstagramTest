//
//  MRInstagramAnnotation.m
//  Audible_InstagramChallenge
//
//  Created by Melvin Ready on 7/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import "MRInstagramAnnotation.h"


@implementation MRInstagramAnnotation

-(instancetype)initWithLocation:(CLLocationCoordinate2D)coordinate withTitle:(NSString*)title andSubtitle:(NSString*)subtitle{
    self = [super init];
    if(self){
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
