//
//  CameraTableViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 23/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import "CameraTableViewController.h"
@import GoogleMaps;

@interface CameraTableViewController ()

@end

@implementation CameraTableViewController {
    // Initializes the google current place variable _placesClient.
    GMSPlacesClient *_placesClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveLocations) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.layer.zPosition -= 1;
    self.tableView.alwaysBounceVertical = YES;
    
    // Allocating and initializing the _placesClient which shows the current places from google.
    _placesClient = [[GMSPlacesClient alloc] init];
    // Allocating and initializing the allLocations Array.
    self.allLocations = [[NSMutableArray alloc] init];
    // Allocating and initializing the allAddresses Array.
    self.allAddresses = [[NSMutableArray alloc] init];
    // Allocating and initializing the allPlaceIds Array.
    self.allPlaceIds = [[NSMutableArray alloc] init];
    // Allocating and initializing the allLatitudes Array.
    self.allLatitudes = [[NSMutableArray alloc] init];
    // Allocating and initializing the allLongitudes Array.
    self.allLongitudes = [[NSMutableArray alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    // Calling the same function from super class.
    [super viewWillAppear:animated];
    
    [self retrieveLocations];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allLocations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Text label of the cell is location.
    cell.textLabel.text = [self.allLocations objectAtIndex:indexPath.row];
    // Subtitle of the cell is the location.
    cell.detailTextLabel.text = [self.allAddresses objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"marker.png"];
    
    return cell;
}

#pragma mark. Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the ID of the location selected by the user and save it in the locationSelected variable.
    self.locationIdSelected = [self.allPlaceIds objectAtIndex:indexPath.row];
    // Get the location selected by the user and save it in the locationSelected variable.    
    self.locationSelected = [self.allLocations objectAtIndex:indexPath.row];
    // Get the latitude selected by the user and save it in the latitude variable.
    self.latitudeSelected = [self.allLatitudes objectAtIndex:indexPath.row];
    // Get the longitude selected by the user and save it in the longitude variable.
    self.longitudeSelected = [self.allLongitudes objectAtIndex:indexPath.row];
}

#pragma mark -IBActions

- (IBAction)cancel:(id)sender {
    // When cancelled is presssed, reset all the variables.
    [self reset];
    
    // Send the user back to Places Nearby
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)post:(id)sender {
    // Check if any image or video was taken or not.
    NSLog(@"%@", self.videoFilePath);
    if (self.image == nil && self.videoFilePath == nil) {
        // If not then alert the user that no photo or video is captured.
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Try Again" message:@"Please capture a photo or video to post" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertView addAction:ok];
        
        [self presentViewController:alertView animated:true completion:nil];
    }
    else if (self.locationIdSelected == nil) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"No Location Tagged" message:@"Please tag a location with your post" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertView addAction:ok];
        
        [self presentViewController:alertView animated:true completion:nil];
    }
    // If the image and video is captured then continue.
    else {
        NSLog(@"%@", self.videoFilePath);
        // Upload the photo by calling the function uploadPhoto.
        [self uploadPost];
        // When photo or video is posted, reset all the variables.
        [self reset];
        // Send the user back to Places Nearby
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - Helper methods

- (void)uploadPost {
    NSData *fileData;
    NSData *fileThumbnail;
    NSString *fileName;
    NSString *fileType;
    NSString *location;
    NSString *locationId;
    NSNumber *people = [[NSNumber alloc] initWithInt:1];
    NSNumber *people1 = [[NSNumber alloc] initWithInt:0];
    NSNumber *latitude;
    NSNumber *longitude;
    if (self.image != nil) {
        UIImage *newImage = [self resizeImage:self.image toWidth:[UIScreen mainScreen].bounds.size.width andHeight:[UIScreen mainScreen].bounds.size.height];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }
    else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: self.videoFilePath options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *err = NULL;
        CMTime requestedTime = CMTimeMake(1, 60);     // To create thumbnail image
        CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err];
        NSLog(@"err = %@, imageRef = %@", err, imgRef);
        UIImage *thumbnailImage = [UIImage imageWithCGImage:imgRef scale:1 orientation:UIImageOrientationRight];
        UIImage *newImage = [self resizeImage:thumbnailImage toWidth:[UIScreen mainScreen].bounds.size.width andHeight:[UIScreen mainScreen].bounds.size.height];
        fileThumbnail = UIImagePNGRepresentation(newImage);
        CGImageRelease(imgRef);    // MUST release explicitly to avoid memory leak
    }
    location = self.locationSelected;
    locationId = self.locationIdSelected;
    latitude = self.latitudeSelected;
    longitude = self.longitudeSelected;
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    PFFile *thumbnail;
    if ([fileType isEqualToString:@"video"]) {
        thumbnail = [PFFile fileWithName:@"thumbnail.png" data:fileThumbnail];
    }
    else {
        thumbnail == nil;
    }
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"An error occurred!" message:@"Please try posting your post again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:ok];
            
            [self presentViewController:alertView animated:true completion:nil];
        }
        else {
            PFObject *post = [PFObject objectWithClassName:@"Posts"];
            
            [post setObject:file forKey:@"file"];
            [post setObject:fileType forKey:@"fileType"];
            if ([fileType isEqualToString:@"video"]) {
                [post setObject:thumbnail forKey:@"fileThumbnail"];
            }
            [post setObject:location forKey:@"location"];
            [post setObject:locationId forKey:@"locationId"];
            [post setObject:point forKey:@"Coordinates"];
            [post setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [post setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [post setObject:[PFUser currentUser] forKey:@"sender"];
            [post setObject:people forKey:@"views1"];
            [post setObject:people1 forKey:@"likes"];
            [post setObject:people1 forKey:@"flagged"];
            [post setObject:people1 forKey:@"Value"];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"An error occurred!" message:@"Please try uploading your post again." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertView addAction:ok];
                    
                    [self presentViewController:alertView animated:true completion:nil];
                }
                else {
                    // Everything was successful!
                    [self reset];
                }
            }];
        }
    }];
}

- (void)reset {
    // When photo or video is cancelled or posted, reset all the variables.
    self.image = nil;
    self.videoFilePath = nil;
    self.locationSelected = nil;
    self.locationIdSelected = nil;
    [self.allAddresses removeAllObjects];
    [self.allLocations removeAllObjects];
    [self.allPlaceIds removeAllObjects];
}

// This function resizes the image. The CG stands for Core Graphics
- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    // Initiate the new size.
    CGSize newSize = CGSizeMake(width, height);
    // Create a rectangle using the two parameters.
    CGRect newRectangle = CGRectMake(0,0, width, height);
    // creates a bitmap graphic context in which we can redraw whtever we want and then capture
    // the context in the rectangle size.
    UIGraphicsBeginImageContext(newSize);
    // Put the image in the resized rectangle.
    [image drawInRect:newRectangle];
    // capture the resized image and return it.
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (void)retrieveLocations {
    
    // Creates a list of all places around you.
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
        }
        else {
            // Goes through each of nearby Places in order of likelihood.
            for (GMSPlaceLikelihood *likelihood in placeLikelihoodList.likelihoods) {
                GMSPlace* place = likelihood.place;
                // Add the location to the allLocation array.
                [self.allLocations addObject:place.name];
                // Add the address to the allAddresses array.
                [self.allAddresses addObject:place.formattedAddress];
                // Add the placeId to the allPlaceIds array.
                [self.allPlaceIds addObject:place.placeID];
                
                NSNumber *tempLatitude = [[NSNumber alloc] initWithDouble:place.coordinate.latitude];
                NSNumber *tempLongitude = [[NSNumber alloc] initWithDouble:place.coordinate.longitude];
                // Add the coordinates to the allLatitides array.
                [self.allLatitudes addObject:tempLatitude];
                // Add the coordinates to the allLongitudes array.
                [self.allLongitudes addObject:tempLongitude];
            }
            // Reload the table otherwise the data will not refresh.
            [self.tableView reloadData];
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        }
        UIImageView *imView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"powered_by_google_on_white@2x"]];
        self.tableView.tableFooterView = imView;
        [self.tableView.tableFooterView setContentMode:UIViewContentModeScaleAspectFit];
        [self.tableView.tableFooterView setContentMode:UIViewContentModeBottom];
        //        imageView.frame = CGRectMake(x, y, width, height);
        self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    }];
    
}

@end
