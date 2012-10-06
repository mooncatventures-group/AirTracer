//

#import "SFUInfoFeature.h"


typedef enum {
	NoneType,
	BurnabySystem,
	SurreySystem,
	VancouverSystem,
	SchoolWide,
	OtherType,
	FacebookType,
	TwitterType,
	SocialType
} SFUDetailType;

// All detail views will derive from this class
@interface SFUDetail : SFUInfoFeature {
	SFUDetailType _detailType;
}

@property (nonatomic, assign) SFUDetailType detailType;

@end
