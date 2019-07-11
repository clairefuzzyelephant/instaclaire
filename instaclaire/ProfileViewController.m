//
//  ProfileViewController.m
//  instaclaire
//
//  Created by clairec on 7/11/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "Parse/Parse.h"
#import "PostCell.h"
#import "PFObject.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImage *photo;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //refreshcontrol
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    //load data
    [self fetchPosts];
}

-(void)fetchPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:PFUser.currentUser];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = posts;
            [self.tableView reloadData];
            NSLog(@"loaded 20 posts");
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    // Create NSURL and NSURLRequest
    [self fetchPosts];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

- (IBAction)logoutTap:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"User log out failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged out successfully");
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
        }
    }];
}

- (IBAction)cameraPress:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    // Do something with the images (based on your use case)
    self.photo = editedImage;
    NSLog(@"selected photo!");
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    //manual segue
    [self performSegueWithIdentifier:@"composeSegue" sender:self];
}

- (IBAction)libraryPress:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    cell.caption.text = post.caption;
    
    //getting UIImage from PFFileObject
    PFFileObject *img = post.image;
    [img getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        UIImage *imageToLoad = [UIImage imageWithData:imageData];
        [cell.postImage setImage:imageToLoad];
    }];
    
    //getting username
    PFUser *user = post.author;
    cell.userHandle.text = user.username;
    //NSLog(@"%@", cell.userHandle.text);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"composeSegue"]){
        UINavigationController *navControl = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navControl.topViewController;
        composeController.image = self.photo;
    }
    else{
        //segue to detail view
        PostCell *tapped = sender;
        Post *post = tapped.post;
        DetailsViewController *dtControl = [segue destinationViewController];
        dtControl.post = post;
    }
}

@end
