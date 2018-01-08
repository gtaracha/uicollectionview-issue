//
//  ViewController.m
//  test
//
//  Created by Grzegorz Taracha on 04.01.2018.
//  Copyright © 2018 Grzegorz Taracha. All rights reserved.
//

#import "ViewController.h"

@interface TestView: UIView
@end
@implementation TestView
@end

@interface MyCollectionView: UICollectionView
@end

@implementation MyCollectionView

-(void) layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews){
        if([subview isKindOfClass:[TestView class]]){
            [self bringSubviewToFront:subview];
        }
    }
}

@end

@interface ViewController ()
@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@end

@implementation ViewController

//  ViewController.m

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Init the Data Source
    
    _dataArray = [[NSArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight", nil];
    
    // init collection view
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[MyCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _testView = [[TestView alloc] initWithFrame:CGRectMake(0, 0, 50, 550)];
    _testView.backgroundColor = [UIColor redColor];
    [_collectionView addSubview:_testView];
    
    // add section insets for layout
    
    [layout setSectionInset:UIEdgeInsetsMake(25, 5, 25, 5)];
    layout.headerReferenceSize = CGSizeMake(0.0, 40.0);
    
    // register the collectionView cell
    [_collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    // register UICollectionHeaderView
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView"];
    
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_collectionView];
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
}

#pragma mark -
#pragma mark - Gesture handling

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if (indexPath == nil) {
        return;
    }
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
        
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            
            if (currentIndexPath == nil) {
                return;
            }
            
            if (![self collectionView:self.collectionView canMoveItemAtIndexPath:currentIndexPath]) {
                return;
            }
            
            //self.selectedItemIndexPath = currentIndexPath;
            //if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:collectionViewLayout:didBeginDraggingItemAtIndexPath:)]) {
                
            //}
        }
            break;
        case UIGestureRecognizerStateCancelled:

            break;
        case UIGestureRecognizerStateEnded: {

        }
            break;
        default:
            break;
    }
}


#pragma mark - CollectionView Header

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"viewForSupplementaryElementOfKind: %@",kind);
    // check if header or footer
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView" forIndexPath:indexPath];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        view.backgroundColor = [UIColor grayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
        label.textColor = [UIColor whiteColor];
        
        // label text
        label.text = [NSString stringWithFormat: @"Section: %li", (long)indexPath.section];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        [headerView addSubview:view];
        
        return headerView;
    }
    
    // return nil if view is not a headerview
    
    return nil;
}

#pragma mark - CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    
    NSLog(@"dataArray count: %lu",(unsigned long)[_dataArray count]);
    
    return [_dataArray count];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView bringSubviewToFront: _testView];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"indexPath: %li",(long)indexPath.row);
    
    // Init a Custom CollectionViewCell Class
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Remove labels on redraw
    
    for (UIView *view in cell.subviews){
        
        [view removeFromSuperview];
    }
    
    // Cell text
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height/2 - 10, cell.frame.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [_dataArray objectAtIndex:indexPath.row];
    [cell addSubview: label];
    
    // Cell Border and Background
    
    cell.layer.borderWidth= 1.0f;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

#pragma mark - CollectionView Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.view.frame.size.width < 1000){
        return CGSizeMake(self.view.frame.size.width/3 - 10, self.view.frame.size.width/3 - 10);
    }
    
    return CGSizeMake(self.view.frame.size.width/2 - 25, self.view.frame.size.width/2 - 25);
}


@end
