//
//  SearchViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 31/12/15.
//  Copyright © 2015 Vishisht Mani Tiwari. All rights reserved.
//

#import "SearchViewController.h"
#import "ImagesViewController.h"
#import "LocationFlowLayout.h"
@import GoogleMaps;

@interface SearchViewController ()

@end

@implementation SearchViewController {
    // Initializes the google current place variable _placesClient.
    GMSAutocompleteResultsViewController *_resultsViewController;
    UISearchController *searchController;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveLocations) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.layer.zPosition -= 1;
    self.collectionView.alwaysBounceVertical = YES;

    
    self.collectionView.collectionViewLayout = [[LocationFlowLayout alloc] init];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
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
    
    // Change the background of nearbyview screen to light grey.
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retrieveLocations];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [searchController setActive:YES];
    [searchController.searchBar becomeFirstResponder];
}

// Handle the user's selection.
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
    searchController.active = NO;
    // Do something with the selected place.
    self.coord = [PFGeoPoint geoPointWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    [query whereKey:@"Coordinates" nearGeoPoint:self.coord withinKilometers:self.kms];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
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

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.moreModifiedLocations count] != 0) {
        return [self.moreModifiedLocations count];
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.collectionView registerClass:[SearchViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    SearchViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
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
    
    } else {
        cell.locationImage.image = [UIImage imageNamed:@"crying.png"];
        cell.locationImage.contentMode = UIViewContentModeScaleToFill;
        cell.locationLabel.text = @"No Yells in this Area";
        [cell.otherLabel setText:[NSString stringWithFormat:@""]];
        cell.locationLabel.textColor = [UIColor colorWithRed:1 green:110.0f/255.0f blue:0 alpha:1];
        cell.otherLabel.textColor = [UIColor colorWithRed:1 green:110.0f/255.0f blue:0 alpha:1];
        [cell.locationLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
        [cell.otherLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedLocationId = nil;
    self.selectedLocation = nil;
    for (int i = 0; i < [self.locationIds count]; i++) {
        if ([[self.locationIds objectAtIndex:i] isEqualToString:[self.moreModifiedLocationIds objectAtIndex:indexPath.row]]){
            self.selectedLocationId = [[self.locationsInformation objectAtIndex:i] valueForKey:@"locationId"];
            self.selectedLocation = [[self.locationsInformation objectAtIndex:i] valueForKey:@"location"];
        }
    }
    [self performSegueWithIdentifier:@"showImages1" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Hides the botton tab bar whenever the login screen is shown.
    if ([segue.identifier isEqualToString:@"showImages1"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImagesViewController *collectionViewController = (ImagesViewController *)segue.destinationViewController;
        collectionViewController.selectedLocation = self.selectedLocation;
        collectionViewController.selectedLocationId = self.selectedLocationId;
        collectionViewController.span = 1.0;
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

- (void) retrieveLocations {
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    _resultsViewController.delegate = self;
    
    searchController = [[UISearchController alloc]
                        initWithSearchResultsController:_resultsViewController];
    searchController.searchResultsUpdater = _resultsViewController;
    
    // Put the search bar in the navigation bar.
    [searchController.searchBar sizeToFit];
    self.navigationItem.titleView = searchController.searchBar;
    
    // When UISearchController presents the results view, present it in
    // this view controller, not one further up the chain.
    self.definesPresentationContext = YES;
    
    // Prevent the navigation bar from being hidden when searching.
    searchController.hidesNavigationBarDuringPresentation = NO;
    
    [self.collectionView reloadData];
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
}

@end

