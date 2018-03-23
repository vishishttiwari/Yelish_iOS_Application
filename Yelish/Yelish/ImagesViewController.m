//
//  ImagesViewController.m
//  Yelish
//
//  Created by Vishisht Mani Tiwari on 15/01/16.
//  Copyright © 2016 Vishisht Mani Tiwari. All rights reserved.
//

#import "ImagesViewController.h"

@interface ImagesViewController ()

@end

@implementation ImagesViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.collectionViewLayout = [[ImagesFlowLayout alloc] init];
    
    self.filesByDate = [[NSArray alloc] init];
    self.filesByValue = [[NSArray alloc] init];
    
    self.coordinate = [[NSArray alloc] init];
    
    self.imagesByDate = [[NSArray alloc] init];
    self.imagesByValue = [[NSArray alloc] init];
    
    self.formatByDate = [[NSArray alloc] init];
    self.formatByValue = [[NSArray alloc] init];
    
    self.thumbnailByDate = [[NSArray alloc] init];
    self.thumbnailByValue = [[NSArray alloc] init];
    
    self.segmentedControl == 0;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveImages) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor colorWithRed:1 green:150.0f/255.0f blue:70.0f/255.0f alpha:1];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.layer.zPosition -= 1;
    self.collectionView.alwaysBounceVertical = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.selectedLocation;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [[UIColor whiteColor] colorWithAlphaComponent:1.0],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Helvetica Neue" size:25.0],
                                                                     NSFontAttributeName,
                                                                     nil]];
    
    [self retrieveImages];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.segmentedControl == 0) {
        return [self.imagesByValue count];
    }
    else if (self.segmentedControl == 1){
        return [self.imagesByDate count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagesViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];

    PFFile *imageObject;
    if (self.segmentedControl == 0) {
        if ([[self.formatByValue objectAtIndex:indexPath.row] isEqualToString:@"video"]) {
            imageObject = [self.thumbnailByValue objectAtIndex:indexPath.row];
            cell.video.hidden = NO;
        }
        else {
            imageObject = [self.filesByValue objectAtIndex:indexPath.row];
            cell.video.hidden = YES;
        }
    }
    else if (self.segmentedControl == 1){
        if ([[self.formatByDate objectAtIndex:indexPath.row] isEqualToString:@"video"]) {
            imageObject = [self.thumbnailByDate objectAtIndex:indexPath.row];
            cell.video.hidden = NO;
        }
        else {
            imageObject = [self.filesByDate objectAtIndex:indexPath.row];
            cell.video.hidden = YES;
        }
    }
    [imageObject getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
        if (!error) {
            cell.locationImages.image = [UIImage imageWithData:data];
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
        ImagesReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        headerView.segmentedControl.tintColor = [UIColor colorWithRed:1 green:111.0f/255.0f blue:0 alpha:1];
        [headerView.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        // This is For the Map
        //=================================================================
        
        [headerView.mapView removeAnnotations:headerView.mapView.annotations];
        
        headerView.mapView.delegate = self;
        
        if ([self.filesByValue count] != 0 && [self.filesByDate count] != 0) {
            self.coordinate = [self.imagesByDate valueForKey:@"Coordinates"];
        
            self.latitude = [[[self.coordinate objectAtIndex:0] valueForKey:@"latitude"] doubleValue];
            self.longitude = [[[self.coordinate objectAtIndex:0] valueForKey:@"longitude"] doubleValue];
        
            CLLocationCoordinate2D center;
        
            center.longitude = self.longitude;
            center.latitude = self.latitude;
        
            MKCoordinateSpan span;
            span.latitudeDelta = self.span;
            span.longitudeDelta = self.span;
        
            MKCoordinateRegion region;
            region.center = center;
            region.span = span;
        
            headerView.mapView.tintColor = [UIColor blackColor];
            [headerView.mapView setRegion:region animated:YES];
        
            Annotation *annotation = [[Annotation alloc] init];
            annotation.coordinate = center;
            [headerView.mapView removeAnnotation:annotation];
            [headerView.mapView addAnnotation:annotation];
        }
        
        //=================================================================
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [headerView.mapView addGestureRecognizer:tap];
        
        [headerView addSubview:headerView.mapView];
        [headerView addSubview:headerView.segmentedControl];
        
        reusableview = headerView;
    }
    
    return reusableview;
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
            detailView.photos = self.imagesByValue;
            detailView.integerValue = 0;
        }
        else {
            detailView.photos = self.imagesByDate;
            detailView.integerValue = 0;
        }
        detailView.currentIndex = self.currentIndex;
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)retrieveImages {
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Posts"];
    query1.cachePolicy = kPFCachePolicyIgnoreCache;
    [query1 whereKey:@"locationId" equalTo:self.selectedLocationId];
    [query1 orderByDescending:@"Value"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error in retrieving Images: %@", error.description); // todo why is this ever happening?
        }
        else {
            self.imagesByValue = objects;
            self.filesByValue = [self.imagesByValue valueForKey:@"file"];
            self.formatByValue = [self.imagesByValue valueForKey:@"fileType"];
            self.thumbnailByValue = [self.imagesByValue valueForKey:@"fileThumbnail"];
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    query.cachePolicy = kPFCachePolicyIgnoreCache;
    [query whereKey:@"locationId" equalTo:self.selectedLocationId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error in retrieving Images: %@", error.description); // todo why is this ever happening?
        }
        else {
            self.imagesByDate = objects;
            self.filesByDate = [self.imagesByDate valueForKey:@"file"];
            self.formatByDate = [self.imagesByDate valueForKey:@"fileType"];
            self.thumbnailByDate = [self.imagesByDate valueForKey:@"fileThumbnail"];
            [self.collectionView reloadData];
        }
    }];
    
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
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

-(void)viewTapped:(UITapGestureRecognizer*)recognizer
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:(@"%@", self.selectedLocation)];
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

@end