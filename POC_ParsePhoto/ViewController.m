//
//  ViewController.m
//  POC_ParsePhoto
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Mick Lerche. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "PCPhoto.h"


@interface ViewController ()
@property PCPhoto *photo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];



}

- (IBAction)onButtonDoSomething:(id)sender {
 //sign up
//    PFUser *user = [PFUser user];
//    user.username = @"mick";
//    user.password = @"pass";
//    user.email = @"emailzzz@example.com";
//
//    // other fields can be set just like with PFObject
//    user[@"phone"] = @"415-392-0202";
//
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            NSLog(@"%@", @"Login created");
//        } else {
//            NSString *errorString = [error userInfo][@"error"];
//            NSLog(@"%@", errorString);
//        }
//    }];

    // login
    [PFUser logInWithUsernameInBackground:@"mick" password:@"pass"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"%@", @"Did log in");
                                        } else {
                                            NSLog(@"%@", @"Failed log in");
                                        }
                                    }];

}
- (IBAction)onAddImageButtonPressed:(id)sender {
    PFUser *currentUser = [PFUser currentUser];

    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"tribble"]);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];


    PCPhoto *photo2 = [PCPhoto new];
    photo2.comment = @"Hoooray for the PCPhoto save";

    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:44.0 longitude:-33.0];
    photo2.photolocation = point;
    photo2.originalImage = imageFile;
    photo2.username = currentUser.username;

    [photo2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.photo = photo2;
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"Photo saved successfully");
        } else {
            NSLog(@"Error while saving photo: %@", error);
        }
    }];

//    PFObject *photo = [PFObject objectWithClassName:@"PCPhoto"];
//    photo[@"comment"] = @"yy My trip to Hawaii!";
//
//    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:44.0 longitude:-33.0];
//    photo[@"location"] = point;
//    photo[@"imageFile"] = imageFile;
//
//    photo[@"username"] = currentUser.username;
//
//    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        self.photo = photo;
//    }];
}

- (IBAction)onCountUserPhotos:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
    [query whereKey:@"username" equalTo:@"mick"];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"User has %d photos", count);
        } else {
            NSLog(@"Error while counting photos: %@", error);
        }
    }];


}

- (IBAction)onCountComments:(id)sender {

        PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
        [query whereKey:@"parent" equalTo:self.photo];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                NSLog(@"Photo has %d Comments", count);
            } else {
                NSLog(@"Error while counting comments: %@", error);
            }
        }];

}

- (IBAction)onAddCommentButtonPressed:(id)sender {
    PFObject *myComment = [PFObject objectWithClassName:@"Comment"];
    myComment[@"content"] = @"Let's do Sushirrito.";

    // Add a relation between the Post and Comment
    myComment[@"parent"] = self.photo;

    // This will save both myPost and myComment
    [myComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"Added comment for Photo");
        } else {
            NSLog(@"Error while adding photo: %@", error);
        }
    }];
}

- (IBAction)onSelectPhotos:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
    [query whereKey:@"username" equalTo:@"mick"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu photos.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PCPhoto *object in objects) {
                NSLog(@"%@", object.comment);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


@end
