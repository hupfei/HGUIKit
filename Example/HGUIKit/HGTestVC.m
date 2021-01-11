//
//  HGTestVC.m
//  HGUIKit_Example
//

#import "HGTestVC.h"
#import "HGTestVM.h"

@interface HGTestVC ()

@property (nonatomic, strong) HGTestVM *viewModel;

@end

@implementation HGTestVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"push" target:self action:@selector(pushAction)];
}

- (void)pushAction {
    [self.viewModel.pushCmd execute:nil];
}

@end
