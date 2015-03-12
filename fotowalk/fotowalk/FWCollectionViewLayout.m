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

static CGFloat const kMaxDistanceForHighlight = 0.1;
static CGFloat const kMaxDistanceForVisible = 0.0625;
static CGFloat const kMarginRight = 20;

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
        CGFloat maxWidth = self.collectionView.bounds.size.width;
        CGFloat x0 = self.collectionView.bounds.origin.x;
        CGFloat x1 = layoutAttributes.center.x - kMarginRight / 2.0;
        CGFloat distance = x1 - x0;
        CGFloat distancePercent = fabsf(distance - maxWidth / 2.0) / maxWidth / 2.0;

        if (distance > 0 && distancePercent < kMaxDistanceForVisible) {
            layoutAttributes.alpha = 1;
            layoutAttributes.transform = CGAffineTransformMakeScale(.9, .9);
        } else {
            layoutAttributes.alpha = 1 - (distancePercent - kMaxDistanceForVisible) * 0.8;
            CGFloat scale = .9 - (distancePercent - kMaxDistanceForVisible) * 0.8;
            layoutAttributes.transform = CGAffineTransformMakeScale(scale, scale);

        }
        if (distance > 0 && distancePercent < kMaxDistanceForHighlight) {
            indexPathToHighlight = layoutAttributes.indexPath;
        }
    }
    [self.delegate collectionViewLayout:self willHighlightCellAtIndexPath:indexPathToHighlight];
    return attributesArray;
}

@end
