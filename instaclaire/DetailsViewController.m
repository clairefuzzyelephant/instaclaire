//
//  DetailsViewController.m
//  instaclaire
//
//  Created by clairec on 7/10/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "DetailsViewController.h"
#import "PFObject.h"
#import "Post.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postUser;
@property (weak, nonatomic) IBOutlet UILabel *postTime;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //getting image
    PFFileObject *img = self.post.image;
    [img getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *imageToLoad = [UIImage imageWithData:imageData];
        [self.postImage setImage:imageToLoad];
    }];
    
    //username
    self.postUser.text = self.post.author.username;
    
    //formatting date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd 'at' HH:mm";
    NSDate *date = self.post.createdAt;
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.postTime.text = dateString;
    
    //caption
    self.postCaption.text = self.post.caption;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
