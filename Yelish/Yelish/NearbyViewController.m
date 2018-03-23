//
//  NearbyViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 22/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import "NearbyViewController.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController
@synthesize kms;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.kms == 0) {
        self.kms = 25;
    }
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UITabBarItem *firstTab = [tabBar.items objectAtIndex:0];
    UITabBarItem *secondTab = [tabBar.items objectAtIndex:1];
    UITabBarItem *thirdTab = [tabBar.items objectAtIndex:2];
    UITabBarItem *forthTab = [tabBar.items objectAtIndex:3];
    UITabBarItem *fifthTab = [tabBar.items objectAtIndex:4];
    thirdTab.image = [[UIImage imageNamed:@"camera.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    thirdTab.selectedImage = [[UIImage imageNamed:@"camera.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    forthTab.image = [[UIImage imageNamed:@"user.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    forthTab.selectedImage = [[UIImage imageNamed:@"user.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    fifthTab.image = [[UIImage imageNamed:@"more.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    fifthTab.selectedImage = [[UIImage imageNamed:@"more.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveLocations) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor colorWithRed:1 green:150.0f/255.0f blue:70.0f/255.0f alpha:1];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.layer.zPosition -= 1;
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.collectionViewLayout = [[LocationFlowLayout alloc] init];
    
    // Initialize and allocate dictionary for saving all information about the location near 8 kms where photo has been taken.
    self.locationsInformation = [[NSArray alloc] init];
    
    self.locations = [[NSMutableArray alloc] init];
    self.locationIds = [[NSMutableArray alloc] init];
    self.modifiedLocations = [[NSMutableArray alloc] init];
    self.modifiedLocationIds = [[NSMutableArray alloc] init];
    self.moreModifiedLocations = [[NSMutableArray alloc] init];
    self.moreModifiedLocationIds = [[NSMutableArray alloc] init];
    
    self.views = [[NSMutableArray alloc] init];
    self.modifiedViews = [[NSMutableArray alloc] init];
    self.moreModifiedViews = [[NSMutableArray alloc] init];
    
    self.likes = [[NSMutableArray alloc] init];
    self.modifiedLikes = [[NSMutableArray alloc] init];
    self.moreModifiedLikes = [[NSMutableArray alloc] init];

    self.frequency = [[NSMutableArray alloc] init];
    self.sum = [[NSMutableArray alloc] init];
    
    self.popularImages = [[NSArray alloc] init];
    self.popularImagesLocations = [[NSArray alloc] init];
    
    
    // Initialize the collection view.
    [self.collectionView registerClass:[NearbyViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Change the background of nearbyview screen to light grey.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (!currentUser) {
        [self login];
    }
}

- (void)login {
    ParseLogInViewController *loginViewController = [[ParseLogInViewController alloc] init];
    loginViewController.delegate = self;
    loginViewController.fields = (PFLogInFieldsUsernameAndPassword
                                  | PFLogInFieldsLogInButton
                                  | PFLogInFieldsSignUpButton
                                  | PFLogInFieldsPasswordForgotten
                                  | PFLogInFieldsFacebook
                                  | PFLogInFieldsTwitter);
    loginViewController.facebookPermissions = @[ @"user_about_me" ];
    
    ParseSignupViewController *signUpController = [[ParseSignupViewController alloc] init];
    signUpController.delegate = self;
    signUpController.fields = (PFSignUpFieldsUsernameAndPassword
                               | PFSignUpFieldsSignUpButton
                               | PFSignUpFieldsEmail
                               | PFSignUpFieldsDismissButton);
    
    loginViewController.signUpController = signUpController;
    
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    
    if ([PFFacebookUtils isLinkedWithUser:user]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                user.username = userData[@"name"];
                [[PFUser currentUser] setUsername:userData[@"name"]];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
    else if ([PFTwitterUtils isLinkedWithUser:user]) {
        NSString *name = [PFTwitterUtils twitter].screenName;
        
        user.username = name;
        [[PFUser currentUser] setUsername:name];
        [[PFUser currentUser] saveEventually];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Login Error" message:@"Invalid Login Parameters" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertView addAction:ok];
    
    [logInController presentViewController:alertView animated:true completion:nil];
    
    [PFUser logOut];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController
           shouldBeginSignUp:(NSDictionary *)info {
    NSString *password = info[@"password"];
    NSString *username = info[@"username"];
    NSString *email = info[@"email"];
    
    if (password.length >= 8 && email.length !=0 && username.length !=0) {
        return true;
    }
    else {
        if (username.length == 0) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sign Up Error" message:@"Please enter a username" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:ok];
            
            [signUpController presentViewController:alertView animated:true completion:nil];
        }
        else if (password.length < 8) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sign Up Error" message:@"Password should be more than 8 characters" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:ok];
            
            [signUpController presentViewController:alertView animated:true completion:nil];
        }
        else {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sign Up Error" message:@"The email address is invalid. Please enter a valid email." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:ok];
            
            [signUpController presentViewController:alertView animated:true completion:nil];
        }
        return false;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Make the navigation controller appear as soon as this screen is shown from login or signup screen.
    [self.navigationController.navigationBar setHidden:NO];
    
    self.navigationItem.title = @"Yelish";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Zapfino" size:20.0f], NSForegroundColorAttributeName: [UIColor whiteColor]
    }];
    
    [self retrieveLocations];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.moreModifiedLocations count] != 0) {
        return [self.moreModifiedLocations count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.collectionView registerClass:[NearbyViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    NearbyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    //cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    if ([self.moreModifiedLocations count] != 0) {
        NSString *location = [self.moreModifiedLocations objectAtIndex:indexPath.row];
        NSString *locationId = [self.moreModifiedLocationIds objectAtIndex:indexPath.row];
        NSNumber *views = [self.moreModifiedViews objectAtIndex:indexPath.row];
        NSNumber *likes = [self.moreModifiedLikes objectAtIndex:indexPath.row];

        cell.locationLabel.text = location;
        [cell.otherLabel setText:[NSString stringWithFormat:@"Views: %@   Likes: %@", views, likes]];
        [cell.locationLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
        [cell.otherLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
        cell.locationLabel.textColor = [UIColor whiteColor];
        cell.otherLabel.textColor = [UIColor whiteColor];
        PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        [query whereKey:@"locationId" equalTo:locationId];
        [query orderByDescending:@"Value"];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error) {
                NSLog(@"error in retrieving Images: %@", error.description); // todo why is this ever happening?
            }
            else {
                NSString *temp = object[@"fileType"];
                PFFile *temp1 = (PFFile *)object[@"file"];
                PFFile *temp2 = (PFFile *)object[@"fileThumbnail"];
                if ([temp isEqualToString:@"video"]) {
                    cell.locationImage.file = temp2;
                } else {
                    cell.locationImage.file = temp1;
                }
                [cell.locationImage loadInBackground];
            }
        }];

//        CGRect bounds = self.collectionView.bounds;
//        [cell updateParallaxOffset:bounds];
//        [cell updateConstraints];
    }
    return cell;
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect bounds = self.collectionView.bounds;
    for (NearbyViewCell *cell in [self.collectionView visibleCells]) {
        
        // Update the parallax position for all visible cells as we
        // are scrolling.
        [cell updateParallaxOffset:bounds];
        [cell updateConstraints];
    }
}
*/
#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedLocationId = nil;
    self.selectedLocation = nil;
    for (int i = 0; i < [self.locationIds count]; i++) {
        if ([[self.locationIds objectAtIndex:i] isEqualToString:[self.moreModifiedLocationIds objectAtIndex:indexPath.row]]){
            self.selectedLocationId = [[self.locationsInformation objectAtIndex:i] valueForKey:@"locationId"];
            self.selectedLocation = [[self.locationsInformation objectAtIndex:i] valueForKey:@"location"];
        }
    }
    [self performSegueWithIdentifier:@"showImages" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Hides the botton tab bar whenever the login screen is shown.
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showImages"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImagesViewController *collectionViewController = (ImagesViewController *)segue.destinationViewController;
        collectionViewController.selectedLocation = self.selectedLocation;
        collectionViewController.selectedLocationId = self.selectedLocationId;
        collectionViewController.span = 0.01;
    }
}

- (void)arrangeArray {
    
    int occurred = 0;
    int position = 0;
    
    [self.modifiedLocations removeAllObjects];
    [self.modifiedLocationIds removeAllObjects];
    [self.moreModifiedLocations removeAllObjects];
    [self.moreModifiedLocationIds removeAllObjects];
    
    [self.modifiedViews removeAllObjects];
    [self.moreModifiedViews removeAllObjects];
    
    [self.modifiedLikes removeAllObjects];
    [self.moreModifiedLikes removeAllObjects];
    
    [self.sum removeAllObjects];
    [self.frequency removeAllObjects];
    
    for (int i = 0; i < [self.locationIds count]; i++) {
        for (int j = 0; j < [self.modifiedLocationIds count]; j++){
            if ([[self.modifiedLocationIds objectAtIndex:j] isEqualToString:[self.locationIds objectAtIndex:i]]){
                occurred = 1;
                position = j;
                break;
            }
        }
        if (occurred == 0){
            NSString *temp1 = [[NSString alloc] initWithString:[self.locations objectAtIndex:i]];
            NSString *temp2 = [[NSString alloc] initWithString:[self.locationIds objectAtIndex:i]];
            NSNumber *temp3 = [[NSNumber alloc] initWithInt:[[self.views objectAtIndex:i] intValue]];
            NSNumber *temp4 = [[NSNumber alloc] initWithInt:[[self.likes objectAtIndex:i] intValue]];
            
            [self.modifiedLocations addObject:temp1];
            [self.modifiedLocationIds addObject:temp2];
            
            [self.modifiedViews addObject:temp3];
            [self.modifiedLikes addObject:temp4];
            
            [self.frequency addObject:[NSNumber numberWithInteger:1]];
        }
        else {
            int temp5 = [[self.frequency objectAtIndex:position] intValue];
            int temp6 = [[self.modifiedViews objectAtIndex:position] intValue];
            int temp7 = temp6 + [[self.views objectAtIndex:i] intValue];
            int temp8 = [[self.modifiedLikes objectAtIndex:position] intValue];
            int temp9 = temp8 + [[self.likes objectAtIndex:i] intValue];
            
            [self.frequency replaceObjectAtIndex:position withObject:[NSNumber numberWithInt:temp5 + 1]];
            [self.modifiedViews replaceObjectAtIndex:position withObject:[NSNumber numberWithInt:temp7]];
            [self.modifiedLikes replaceObjectAtIndex:position withObject:[NSNumber numberWithInt:temp9]];
        }
        occurred = 0;
    }
    
    for (int k = 0; k < [self.frequency count]; k++) {
        NSNumber *temp10 = [[NSNumber alloc] initWithInt:[[self.frequency objectAtIndex:k] intValue] + (2 * [[self.modifiedViews objectAtIndex:k] intValue]) + (5 * [[self.modifiedLikes objectAtIndex:k] intValue]) + 1];
        [self.sum addObject:temp10];
    }
    
    int largest = 0;
    int newposition = 0;
    for (int i = 0; i < [self.sum count]; i++) {
        largest = 0;
        newposition = 0;
        for (int j = 0; j < [self.sum count]; j++){
            if ([[self.sum objectAtIndex:j] intValue] > largest) {
                largest = [[self.sum objectAtIndex:j] intValue];
                newposition = j;
            }
        }
        [self.sum replaceObjectAtIndex:newposition withObject:[NSNumber numberWithInt:0]];
        NSString *temp11 = [[NSString alloc] initWithString:[self.modifiedLocations objectAtIndex:newposition]];
        NSString *temp12 = [[NSString alloc] initWithString:[self.modifiedLocationIds objectAtIndex:newposition]];
        NSNumber *temp13 = [[NSNumber alloc] initWithInt:[[self.modifiedViews objectAtIndex:newposition] intValue]];
        NSNumber *temp14 = [[NSNumber alloc] initWithInt:[[self.modifiedLikes objectAtIndex:newposition] intValue]];
        [self.moreModifiedLocations addObject:temp11];
        [self.moreModifiedLocationIds addObject:temp12];
        [self.moreModifiedViews addObject:temp13];
        [self.moreModifiedLikes addObject:temp14];
    }
}

- (void)retrieveLocations {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint * _Nullable geoPoint, NSError * _Nullable error) {
        if (error) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"OOPS..." message:@"Yelish Needs Your location to work. Please open your settings and turn the Location On for Yelish" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:ok];
            
            [self presentViewController:alertView animated:true completion:nil];
        }
        else {
            
            PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [query whereKey:@"Coordinates" nearGeoPoint:geoPoint withinKilometers:self.kms];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error in geo query: %@", error.description); // todo why is this ever happening?
                }
                else {
                    self.locationsInformation = objects;
                    self.views = [self.locationsInformation valueForKey:@"views1"];
                    self.likes = [self.locationsInformation valueForKey:@"likes"];
                    self.locations = [self.locationsInformation valueForKey:@"location"];
                    self.locationIds = [self.locationsInformation valueForKey:@"locationId"];
                    [self arrangeArray];
                    [self.collectionView reloadData];
                }
            }];
            
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
    [self.collectionView reloadData];
}

@end
