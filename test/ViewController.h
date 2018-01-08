#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSArray *dataArray;
@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property(nonatomic, strong) UIView *testView;

@end
