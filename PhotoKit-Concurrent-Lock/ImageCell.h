// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset, ImageFetchThrottler;

/// Cell that displays a signle image.
@interface ImageCell : UICollectionViewCell

/// Set \c asset as the \c PHAsset to fetch image with. Setting this property again during a
/// previous fetch will cancel the previous fetch.
- (void)setAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
