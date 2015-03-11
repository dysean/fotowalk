//
//  FWCollectionViewLayout.m
//  fotowalk
//
//  Created by Danilo Resende on 3/7/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "FWCollectionViewLayout.h"

// TODO: centralize first image and last image in the center of the view port
// TODO: implement Protocol to let the view know which index is being mostly visible
// TODO: move constants to be public properties of this custom layout class

@implementation FWCollectionViewLayout

static CGFloat const kMaxDistanceForVisible = 0.1;

- (void)prepareLayout {
    // TODO: cache UICollectionViewLayoutAttributes objects
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    NSIndexPath *indexPathToHighlight = nil;
    for (UICollectionViewLayoutAttributes *layoutAttributes in attributesArray) {
        CGFloat x0 = layoutAttributes.center.x;
        CGFloat x1 = self.collectionView.center.x + self.collectionView.bounds.origin.x;
        CGFloat totalWidth = self.collectionView.bounds.size.width;
        CGFloat distancePercent = fmin(fabsf(x1 - x0), totalWidth) / totalWidth;

        if (distancePercent < kMaxDistanceForVisible) {
            layoutAttributes.alpha = 1;
            layoutAttributes.transform = CGAffineTransformMakeScale(1.0, 1.0);
            indexPathToHighlight = layoutAttributes.indexPath;
        } else {
            layoutAttributes.alpha = 1 - (distancePercent - kMaxDistanceForVisible) * 0.8;
            CGFloat scale = 1 - (distancePercent - kMaxDistanceForVisible) * 0.5;
            layoutAttributes.transform = CGAffineTransformMakeScale(scale, scale);

        }
    }
    if (indexPathToHighlight) {
        [self.delegate collectionViewLayout:self willHighlightCellAtIndexPath:indexPathToHighlight];
    }
    return attributesArray;
}

@end
