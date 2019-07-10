//
//  DetailsViewController.h
//  instaclaire
//
//  Created by clairec on 7/10/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Post *post;
@end

NS_ASSUME_NONNULL_END
