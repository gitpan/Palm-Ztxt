package Palm::Ztxt;

use 5.006001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Palm::Ztxt ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = sprintf "%s.%s%s", q$Name: Rel-0_36 $ =~ /^Name: Rel-(\d+)_(\d+)(_\d+|)\s*$/, 9999,999,999;


require XSLoader;
XSLoader::load('Palm::Ztxt', $VERSION);


1;
__END__

=head1 NAME

Palm::Ztxt - Perl extension for creating and manipulating zTXTs using libztxt.

=head1 DESCRIPTION

This module is NOT related to Palm::ZTxt module found on the weasel reader
website (http://gutenpalm.sourceforge.net/files/Palm-ZText-0.1.tar.gz)
This is an XS interface to the ztxt library used by the Weasel Reader
(http://gutenpalm.sourceforge.net/) that allows the creation, and modification 
of zTXTs. This module also extends on libztext somewhat to give access to some
features that are not in libztxt itself such as the ability to delete
annotations and bookmarks. 

As of right now this module is ALPHA and NOT STABLE it may segfault on you and 
probably will unless you know how to use the ztxt C API.  The API will change 
to become more perlish.


=head1 SYNOPSIS

  use Palm::Ztxt;
  my $ztxt = new Palm::Ztxt;

  $ztxt->set_title($title);
  $ztxt->set_data($data);
  $ztxt->add_bookmark($title, $offset);
  $ztxt->add_annotation($title, $offset);
  $ztxt->process();
  $ztxt->generate();
  my $zbook = $ztxt->get_output();

  $ztxt = new Palm::Ztxt;
  $ztxt->disect($zbook);
  my $title = $ztxt->get_title();
  my $book = $ztxt->get_input();
  my $bookmarks = $ztxt->get_bookmarks();
  my $get_annotations = $ztxt->get_annotations();
  $ztxt->delete_bookmark($title, $offset);    # Not tested -- don't use
  $ztxt->delete_annotation($title, $offset);  # Not tested -- don't use

  $ztxt->set_type($type);
  $type = $ztxt->get_type();
  $ztxt->set_wbits($wbits);
  $wbits = $ztxt->get_wbits();
  $ztxt->set_compressiontype($type);
  $type = $ztxt->get_compressiontype();
  $ztxt->set_attribs($attribs);
  $attribs = $ztxt->get_attribs();
  $ztxt->set_creator($creator);
  $creator = $ztxt->get_attribs();





=head2 EXPORT

None.


=head1 NOTES

To get this to work without segfaulting, for now,  you have to 
$ztxt->process(),$ztxt->generate() before you call $ztxt->get_output()


=head1 SEE ALSO

For more information refer to the libztxt libraries that come with the 
Weasel Reader.

For help/questions/problems There is a mailing list set up for this module. 
To subscribe to the mailing lits, send an empty email to  ""

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Rudolf Lippan E<lt>rlippan@remotelinux.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Rudolf Lippan E<lt>rlippan@remotelinux.comE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
