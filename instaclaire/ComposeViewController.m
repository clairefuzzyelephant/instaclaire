//
//  ComposeViewController.m
//  instaclaire
//
//  Created by clairec on 7/9/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController ()

@property (strong, nonatomic) IBOutlet UITextView *captionText;
@property (strong, nonatomic) IBOutlet UIImageView *imagePic;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imagePic.image = self.image;
}

- (IBAction)tapPost:(id)sender {
    
    NSString *caption = _captionText.text;
    
    [Post postUserImage:self.image withCaption:caption withCompletion:nil];
    
    [self dismissViewControllerAnimated:true completion:nil];
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
