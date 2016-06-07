//
//  ViewController.m
//  PhotoKit-Concurrent-Lock
//
//  Created by Barak Yoresh on 06/06/2016.
//  Copyright © 2016 Lightricks. All rights reserved.
//

#import "ViewController.h"

#import <Photos/Photos.h>

#import "ImageCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

/// Camera roll fetch result as a data source.
@property (readonly, nonatomic) PHFetchResult<PHAsset *> *dataSource;

/// Colleciton view to display images in.
@property (readonly, nonatomic) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    assert(status == PHAuthorizationStatusAuthorized);
    [self.collectionView reloadData];
  }];

  [self setupDataSource];
  [self setupCollectionView];
}

- (void)setupDataSource {
  PHFetchResult<PHAssetCollection *> *fetchResults =
      [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                               subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                               options:0];
  assert(fetchResults > 0);
  _dataSource = [PHAsset fetchAssetsInAssetCollection:fetchResults.firstObject options:0];
}

- (void)setupCollectionView {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  CGFloat cellWidth = (self.view.bounds.size.width / 4) - 1;
  layout.itemSize = CGSizeMake(cellWidth, cellWidth);
  layout.minimumInteritemSpacing = 1.0;
  layout.minimumLineSpacing = 1.0;
  _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                       collectionViewLayout:layout];
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  [self.collectionView registerClass:[ImageCell class]
          forCellWithReuseIdentifier:@"cell"];
  [self.view addSubview:self.collectionView];
}

#pragma mark -
#pragma mark UICollectionViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
      forIndexPath:indexPath];

  cell.asset = [self.dataSource objectAtIndex:indexPath.item];

  return cell;
}

#pragma mark -
#pragma mark UICollecitonViewDelegate
#pragma mark -

@end
