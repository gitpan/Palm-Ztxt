#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include <ztxt.h>


typedef struct perl_ztxt {
	ztxt*	db;
} perl_ztxt_t;

typedef ztxt Pztxt;

MODULE = Palm::Ztxt		PACKAGE = Palm::Ztxt
PROTOTYPES: ENABLE



Pztxt *
new(class_name)
	char *class_name;
	PREINIT:
		ztxt *db;
	CODE:
		db = ztxt_init();
		ztxt_set_data(db," ",2); /*If data be < 2 segfault! on process*/
		ztxt_set_title(db,"");
		RETVAL = db;
	OUTPUT:
		RETVAL


MODULE = Palm::Ztxt		PACKAGE = PztxtPtr

void
set_title(db, title)
	Pztxt *db;
	char *title;
	CODE:
		ztxt_set_title(db, title);


char *
get_title(db)
	Pztxt *db;
	CODE:
		RETVAL = (db)->dbHeader->name;
	OUTPUT:
		RETVAL


void
set_output(sv_db, output_sv)
	SV *sv_db;
	SV *output_sv;
	PREINIT:
		char *output;
		STRLEN output_len;
	CODE:
		output = SvPV(output_sv, output_len);
		ztxt_set_output((ztxt *)SvIVX(sv_db), output, (long)output_len);


void
set_data(db, data_sv)
	Pztxt *db;
	SV *data_sv;
	PREINIT:
		char *data;
		STRLEN len;
	CODE:
		data = SvPV(data_sv, len);
		ztxt_set_data(db, data, (long)len);


SV *
get_output (db)
	Pztxt * db;
	PREINIT:
		char *output;
		long output_len;
	CODE:
		output = ztxt_get_output(db);
		output_len = ztxt_get_outputsize((db));
		RETVAL = newSVpvn(output, output_len);
	OUTPUT:
		RETVAL


SV *
get_input(db)
	Pztxt *db;
	PREINIT:
		char *input;
		long input_len;
	CODE:
		input = ztxt_get_input(db);
		input_len = ztxt_get_inputsize(db);
		RETVAL =  newSVpv(input, input_len);
	OUTPUT:
		RETVAL


void
process(db, method, len)
	Pztxt *db;
	int method;
	int len;
	CODE:
		ztxt_process(db, method, len);
	

void
generate(db)
	Pztxt *db;
	CODE:
		ztxt_generate_db(db);


void
disect(db, data_sv)
	Pztxt *db;
	SV * data_sv;
	PREINIT:
		char *zbook;
		STRLEN	len;
	CODE:
		zbook = SvPV(data_sv, len);

		ztxt_set_output(db, zbook, len);
		ztxt_disect(db);
		ztxt_set_output(db, NULL, 0);


int
crc32(crc, buff_sv)
	int crc;
	SV *buff_sv;
	PREINIT:
		const void *buf;
		int len;
	CODE:
		buf = SvPV(buff_sv, len);
		RETVAL = ztxt_crc32(crc, buf, len);
	OUTPUT:
		RETVAL


void
set_type(db, type)
	Pztxt *db;
	long type;
	CODE:
		ztxt_set_type(db, type);


# _get_type

void
set_wbits(db, wbits)
	Pztxt *db;
	int wbits;
	CODE:
		ztxt_set_wbits(db, wbits);

# _get_wbits

void
set_compressiontype(db, comp_type)
	Pztxt *db;
	int comp_type;
	CODE:
		ztxt_set_compressiontype(db, comp_type);

#_get_compressiontype

void
set_attribs(db, attribs)
	Pztxt *db;
	short attribs;
	CODE:
		ztxt_set_attribs(db, attribs);

#_get_attribs

void
set_creator(db, creator)
	Pztxt *db;
	int creator;
	CODE:
		ztxt_set_creator(db, creator);

#_get_creator



SV *
get_bookmarks(db)
	Pztxt *db;
	PREINIT:
		bmrk_node *list;
		bmrk_node *node;
		SV *title;
		SV *offset;
		HV *bookmark;
		AV *array;
	CODE:
		array = newAV();
		sv_2mortal((SV *)array);

		list = ztxt_get_bookmarks(db);

		if (list) {
		    for (node = list; node; node = node->next) {
			bookmark = newHV();
			title = newSVpv(node->title, 0);
			offset = newSViv((IV)node->offset);
			hv_store(bookmark, "title", sizeof("title")-1, title, 0);
			hv_store(bookmark,"offset",sizeof("offset")-1,offset,0);
			av_push(array, newRV((SV *)sv_2mortal((SV *)bookmark)));
		    }
		}

		RETVAL =  newRV((SV *)array);
	OUTPUT:
		RETVAL

void
add_bookmark(db, title, offset)
	Pztxt *db;
	char *title;
	long offset;
	PREINIT:
	CODE:
		ztxt_add_bookmark(db, title, offset);


int
delete_bookmark(db, title, offset)
	Pztxt *db;
	char *title;
	long offset;
	PREINIT:
		bmrk_node *list;
		bmrk_node *node;
		bmrk_node *prev;
	CODE:
		list = ztxt_get_bookmarks(db);

		if (list) {
		    /* XXX: ther perl string might not be null terminated?
		       Or does the typemap automatically add the term null?*/
			for (node = list;node;prev = node, node = node->next) {
				if (strcmp(node->title, title) && 
				    node->offset == offset)
				{
					prev->next = node->next;
					/*
					TODO: Free this node
					free(node->title);
					free(node);
					*/
					goto out;
					RETVAL = 1;
				}
			}
		}
		RETVAL = 0;
		out:
	OUTPUT:
		RETVAL


SV *
get_annotations(db)
	Pztxt *db;
	PREINIT:
		anno_node *list;
		anno_node *node;
		SV *title;
		SV *offset;
		SV *anno_txt;
		HV *anno;
		AV *array;
	CODE:
		array = newAV();
		sv_2mortal((SV *)array);

		list = ztxt_get_annotations(db);

		if (list) {
		    for (node = list; node; node = node->next) {
			anno = newHV();
			title = newSVpv(node->title, 0);
			offset = newSViv((IV)node->offset);
			anno_txt = newSVpv(node->anno_text,0);
			hv_store(anno, "title", sizeof("title")-1, title, 0);
			hv_store(anno, "offset", sizeof("offset")-1,offset,0);
			hv_store(anno, "annotation", 
				sizeof("annotation")-1,anno_txt,0);

			av_push(array,newRV((SV*)sv_2mortal((SV *)anno)));
		    }
		}

		RETVAL =  newRV((SV *)array);
	OUTPUT:
		RETVAL


int
delete_annotation(db, title, offset, annotation)
	Pztxt *db;
	char *title;
	long offset;
	char *annotation;
	PREINIT:
		anno_node *list;
		anno_node *node;
		anno_node *prev;
	CODE:
		list = ztxt_get_annotations(db);

		if (list) {
		    /* XXX: the perl string might not be null terminated?
		       Or does the typemap automatically add the term null?*/
			for (node = list;node;prev = node, node = node->next) {
				if (strcmp(node->title, title) && 
				    node->offset == offset &&
			    	    strcmp(node->anno_text, annotation))
				{
					prev->next = node->next;
					/* TODO: Free this node
					free(node->title);
					free(node->anno_text);
					free(node);
					*/
					RETVAL = 1;
					goto out;
				}
			}
		}
		RETVAL = 0;
		out:
	OUTPUT:
		RETVAL


void
add_annotation(db, title, offset, annotation)
	Pztxt *db;
	char *title;
	long offset;
	char *annotation;
	PREINIT:
	CODE:
		ztxt_add_annotation(db, title, offset, annotation);


void
DESTROY(db)
	Pztxt *db
	CODE:
		ztxt_free(db);



