use 5.006001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Palm::Ztxt',
    'VERSION_FROM'	=> 'Ztxt.pm', # finds $VERSION
    'PREREQ_PM'		=> {'Test::More'  =>  0}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM	=> 'Ztxt.pm', # retrieve abstract from module
       AUTHOR		=> 'Rudolf Lippan <rlippan@remotelinux.com>') : ()),
    'LIBS'		=> ['-L/Install/unpacked/makeztxt-1.60/libztxt -lztxt -lz'],
    'DEFINE'		=> '',
    'INC'		=> '-I. -I/Install/unpacked/makeztxt-1.60/ -I/Install/unpacked/makeztxt-1.60/libztxt',
	# Un-comment this if you add C files to link with later:
    # 'OBJECT'		=> '$(O_FILES)', # link all the C files too
);
