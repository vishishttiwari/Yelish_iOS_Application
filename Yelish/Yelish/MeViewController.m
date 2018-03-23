//
//  MeViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 21/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.collectionViewLayout = [[MeFlowLayout alloc] init];
    
    self.filesByName = [[NSArray alloc] init];
    self.filesByLike = [[NSArray alloc] init];
    
    self.postsByLike = [[NSArray alloc] init];
    
    self.imagesByName = [[NSArray alloc] init];
    self.imagesByLike = [[NSMutableArray alloc] init];
    
    self.formatByName = [[NSArray alloc] init];
    self.formatByLike = [[NSArray alloc] init];
    
    self.thumbnailByName = [[NSArray alloc] init];
    self.thumbnailByLike = [[NSArray alloc] init];
    
    self.coordinate = [[NSArray alloc] init];
    self.latitudes = [[NSArray alloc] init];
    self.longitudes = [[NSArray alloc] init];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveImages) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor colorWithRed:1 green:150.0f/255.0f blue:70.0f/255.0f alpha:1];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.layer.zPosition -= 1;
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.title = [[PFUser currentUser] username];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [[UIColor whiteColor] colorWithAlphaComponent:1.0],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Helvetica Neue" size:25.0],
                                                                     NSFontAttributeName,
                                                                     nil]];
    
    [self retrieveImages];
    self.temp = 0;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.segmentedControl == 0) {
        return [self.imagesByName count];
    }
    else {
        return [self.imagesByLike count];;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    
    PFFile *imageObject;
    if (self.segmentedControl == 0) {
        if ([[self.formatByName objectAtIndex:indexPath.row] isEqualToString:@"video"]) {
            imageObject = [self.thumbnailByName objectAtIndex:indexPath.row];
            cell.video.hidden = NO;
        }
        else {
            imageObject = [self.filesByName objectAtIndex:indexPath.row];
            cell.video.hidden = YES;
        }
    }
    else if (self.segmentedControl == 1){
        if ([[self.formatByLike objectAtIndex:indexPath.row] isEqualToString:@"video"]) {
            imageObject = [self.thumbnailByLike objectAtIndex:indexPath.row];
            cell.video.hidden = NO;
        }
        else {
            imageObject = [self.filesByLike objectAtIndex:indexPath.row];
            cell.video.hidden = YES;
        }
    }
    
    [imageObject getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
        if (!error) {
            cell.images.image = [UIImage imageWithData:data];
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndex = indexPath.row;
    [self performSegueWithIdentifier:@"showImage" sender:self];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        MeReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        headerView.segmentedControl.tintColor = [UIColor colorWithRed:1 green:111.0f/255.0f blue:0 alpha:1];
        [headerView.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        // This is For the Map
        //=================================================================
        
        [headerView.mapView removeAnnotations:headerView.mapView.annotations];

        headerView.mapView.delegate = self;
        
        MKCoordinateSpan span;
        
        if (self.segmentedControl == 0) {
            self.coordinate = [self.imagesByName valueForKey:@"Coordinates"];
            span.latitudeDelta = 0.1;
            span.longitudeDelta = 0.1;
        }
        else {
            self.coordinate = [self.imagesByLike valueForKey:@"Coordinates"];
            span.latitudeDelta = 50;
            span.longitudeDelta = 50;
        }

        self.latitudes = [self.coordinate valueForKey:@"latitude"];
        self.longitudes = [self.coordinate valueForKey:@"longitude"];

        CLLocationCoordinate2D center;
            
        center = headerView.mapView.userLocation.coordinate;
            
        MKCoordinateRegion region;
        region.center = center;
        region.span = span;
        headerView.mapView.tintColor = [UIColor blackColor];
        
        CLLocationCoordinate2D centerForMap;
        
        for (int i = 0; i < [self.latitudes count]; i++) {
        
            centerForMap.longitude = [[self.longitudes objectAtIndex:i] doubleValue];
            centerForMap.latitude = [[self.latitudes objectAtIndex:i] doubleValue];

            Annotation *annotation = [[Annotation alloc] init];
            annotation.coordinate = centerForMap;
            [headerView.mapView removeAnnotation:annotation];
            [headerView.mapView addAnnotation:annotation];
        }
        
 //       [headerView.mapView setRegion:region animated:NO];
        //=================================================================

        [headerView addSubview:headerView.mapView];
        [headerView addSubview:headerView.segmentedControl];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    pinView.pinTintColor = [UIColor colorWithRed:1 green:111.0f/255.0f blue:0 alpha:1];
    return pinView;
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    if (self.temp == 0) {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.1;
        span.longitudeDelta = 0.1;
        CLLocationCoordinate2D location;
        location.latitude = aUserLocation.coordinate.latitude;
        location.longitude = aUserLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [aMapView setRegion:region animated:YES];
        self.temp = 1;
    }
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)control
{
    if (self.segmentedControl == 0) {
        self.segmentedControl = 1;
    }
    else {
        self.segmentedControl = 0;
    }
    [PFQuery clearAllCachedResults];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Hides the botton tab bar whenever the login screen is shown.
    if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        DetailViewController *detailView = (DetailViewController *)segue.destinationViewController;
        if (self.segmentedControl == 0) {
            detailView.photos = self.imagesByName;
            detailView.integerValue = 1;
        }
        else {
            detailView.photos = self.imagesByLike;
            detailView.integerValue = 0;
        }
        detailView.currentIndex = self.currentIndex;
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)retrieveImages {
    
    [self.imagesByLike removeAllObjects];

    PFQuery *query1 = [PFQuery queryWithClassName:@"Like"];
    query1.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query1 whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query1 includeKey:@"toPost"];
    [query1 orderByDescending:@"createdAt"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error in retrieving Images: %@", error.description); // todo why is this ever happening?
        }
        else {
            for (PFObject *underobject in [objects objectEnumerator])
            {
                PFObject *post = underobject[@"toPost"];
                [self.imagesByLike addObject:post];
            }
            self.filesByLike = [self.imagesByLike valueForKey:@"file"];
            self.formatByLike = [self.imagesByLike valueForKey:@"fileType"];
            self.thumbnailByLike = [self.imagesByLike valueForKey:@"fileThumbnail"];
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query whereKey:@"senderId" equalTo:[PFUser currentUser].objectId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error in retrieving Images: %@", error.description); // todo why is this ever happening?
        }
        else {
            self.imagesByName = objects;
            self.filesByName = [self.imagesByName valueForKey:@"file"];
            self.formatByName = [self.imagesByName valueForKey:@"fileType"];
            self.thumbnailByName = [self.imagesByName valueForKey:@"fileThumbnail"];
            [self.collectionView reloadData];
        }
    }];

    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
}

- (IBAction)logout:(id)sender {
    // Log out the user.
    [PFUser logOut];
    
    [self login];
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

@end
