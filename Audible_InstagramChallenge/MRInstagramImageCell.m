//
//  MRInstagramImageCell.m
//  Audible_InstagramChallenge
//
//  Created by Melvin Ready on 7/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import "MRInstagramImageCell.h"

@implementation MRInstagramImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _instagramImages = [UIImageView new];
        _loadingIndicator = [UIActivityIndicatorView new];
        _loadingIndicator.hidesWhenStopped = true;
        _loadingIndicator.color = [UIColor blackColor];
        
        [self addSubview:_instagramImages];
        [self addSubview:_loadingIndicator];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.instagramImages.frame = self.bounds;
    self.loadingIndicator.center = self.instagramImages.center;
}

@end
