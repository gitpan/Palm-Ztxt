use 5.006001;
use ExtUtils::MakeMaker;
use strict;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
my $ztxt_home = $ENV{ZTXT_HOME};
$ztxt_home ||= 
    prompt('make_ztxt home direcotry [/Install/unpacked/makeztxt-1.60]:');
$ztxt_home ||= '/Install/unpacked/makeztxt-1.60';

my $ztxt_lib = $ztxt_home."/libztxt";
WriteMakefile(
    'NAME'		=> 'Palm::Ztxt',
    'VERSION_FROM'	=> 'Ztxt.pm', # finds $VERSION
    'PREREQ_PM'		=> {'Test::More' => 0}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM	=> 'Ztxt.pm', # retrieve abstract from module
       AUTHOR		=> 'Rudolf Lippan <rlippan@remotelinux.com>') : ()),
    'LIBS'		=> ["-L$ztxt_lib -lztxt -lz"],
    'DEFINE'		=> '',
    'INC'		=> "-I. -I$ztxt_home -I$ztxt_lib",
	# Un-comment this if you add C files to link with later:
    # 'OBJECT'		=> '$(O_FILES)', # link all the C files too
);
