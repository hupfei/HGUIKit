//
//  HGCommonViewModel.m
//  HGUIKit
//

#import "HGCommonViewModel.h"

@interface HGCommonViewModel ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSDictionary *params;
@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCmd;

@end

@implementation HGCommonViewModel

- (instancetype)initWithTitle:(nullable NSString *)title {
    return [self initWithTitle:title params:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title params:(nullable NSDictionary *)params {
    self = [super init];
    if (self) {
        self.title = title;
        self.params = params;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        
        [self didInitialize];
    }
    return self;
}

- (UIImage *)imageWithName:(NSString *)name {
    static NSBundle *resourceBundle = nil;
    if (!resourceBundle) {
        NSBundle *mainBundle = [NSBundle bundleForClass:self.class];
        NSString *resourcePath = [mainBundle pathForResource:@"HGUIKit" ofType:@"bundle"];
        resourceBundle = [NSBundle bundleWithPath:resourcePath];
    }
    return [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
}

@end

@implementation HGCommonViewModel (HGSubclassingHooks)

- (void)didInitialize {
    @weakify(self)
    self.requestRemoteDataCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[self requestRemoteData] takeUntil:self.rac_willDeallocSignal];
    }];
}

- (RACSignal *)requestRemoteData {
    return [RACSignal empty];
}

@end
