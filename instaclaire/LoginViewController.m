//
//  LoginViewController.m
//  instaclaire
//
//  Created by clairec on 7/8/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SignUpViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loginUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}


- (IBAction)exitKeyboard:(id)sender {
    
    [self.view endEditing:YES];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
////     Get the new view controller using [segue destinationViewController].
////     Pass the selected object to the new view controller.
//}


@end
