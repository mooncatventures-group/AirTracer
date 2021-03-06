
#import "System.h"


@implementation System

@synthesize hostname;
@synthesize machine;
@synthesize model;
@synthesize ncpu;
@synthesize physmem;
@synthesize usermem;
@synthesize pagesize;
@synthesize floatingpt;
@synthesize arch;
@synthesize osrel;
@synthesize osrev;
@synthesize ostype;
@synthesize kernelver;
@synthesize uniqueIdentifier;
@synthesize localizedName;
@synthesize uimodel;
@synthesize systemName;
@synthesize systemVersion;
@synthesize ldavg;
@synthesize vectorunit;
@synthesize cpu_freq;
@synthesize cacheline;
@synthesize l1icachesize;
@synthesize l1dcachesize;
@synthesize l2settings;
@synthesize l2cachesize;
@synthesize l3settings;
@synthesize l3cachesize;
@synthesize bus_freq;
@synthesize tb_freq;
@synthesize memsize;
@synthesize free_count;
@synthesize active_count;
@synthesize inactive_count;
@synthesize wire_count;

- (void)dealloc {
	
}

@end
