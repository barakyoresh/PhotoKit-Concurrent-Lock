// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "ImageCell.h"

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell ()

/// Current image request used for cancellation.
@property (nonatomic) PHImageRequestID currentRequest;

/// Image view to display image in.
@property (readonly, nonatomic) UIImageView *imageView;

@end

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    super.backgroundColor = [UIColor lightGrayColor];
    self.currentRequest = -1;
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:self.imageView];
  }
  return self;
}

- (void)setAsset:(PHAsset *)asset {
  if (self.currentRequest != -1) {
    [[PHImageManager defaultManager] cancelImageRequest:self.currentRequest];
  }

  self.imageView.image = nil;

  PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
  options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
  options.resizeMode = PHImageRequestOptionsResizeModeFast;

  CGSize imageSize = CGSizeMake(self.contentView.frame.size.width * [[UIScreen mainScreen] scale],
                                self.contentView.frame.size.height * [[UIScreen mainScreen] scale]);

  __weak ImageCell *weakSelf = self;
  self.currentRequest = [[PHImageManager defaultManager] requestImageForAsset:asset
      targetSize:imageSize contentMode:PHImageContentModeAspectFill
      options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
          if (![info[PHImageCancelledKey] boolValue]) {
            weakSelf.imageView.image = result;
          }
      }];
}

@end

NS_ASSUME_NONNULL_END
