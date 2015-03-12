//
//  PhotoWalkTableViewCell.m
//  fotowalk
//
//  Created by Sean Dy on 3/8/15.
//  Copyright (c) 2015 fotowalkers. All rights reserved.
//

#import "PhotoWalkTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Location.h"
#import "Media.h"

@interface PhotoWalkTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *walkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *walkImageView;

@end

@implementation PhotoWalkTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor blackColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhotoWalk:(PhotoWalk *)photoWalk {
    _photoWalk = photoWalk;
    
    PhotoWalk *currentWalk = self.photoWalk;
    NSLog(@"%@",currentWalk.name);
    self.walkNameLabel.text = currentWalk.name;
    self.walkDistanceLabel.text = [NSString stringWithFormat:@"%0.fmi", currentWalk.length/1.6];
    
    Location *firstLocation = currentWalk.locations[0];
    Media *firstPhoto = firstLocation.photos[0];
    NSLog(@"%@",firstPhoto.url);
    [self.walkImageView setImageWithURL:[NSURL URLWithString:firstPhoto.url]];
}

@end
