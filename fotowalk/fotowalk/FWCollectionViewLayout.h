//
//  FWCollectionViewLayout.h
//  fotowalk
//
//  Created by Danilo Resende on 3/7/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWCollectionViewLayout;

@protocol FWCollectionViewLayoutDelegate <NSObject>

- (void)collectionViewLayout:(FWCollectionViewLayout *)collectionViewLayout
willHighlightCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FWCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<FWCollectionViewLayoutDelegate> delegate;

@end
