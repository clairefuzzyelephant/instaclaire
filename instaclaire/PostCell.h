//
//  PostCell.h
//  instaclaire
//
//  Created by clairec on 7/9/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *caption;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) IBOutlet UIImageView *userProfile;
@property (strong, nonatomic) IBOutlet UILabel *userHandle;

@property (strong, nonatomic) Post *post;


@end

NS_ASSUME_NONNULL_END
