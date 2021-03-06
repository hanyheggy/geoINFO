# Makefile for geoINFO with embeded SQL of DB2 Universal Database
# C sample programs -- LINUX operating system

# Enter one of the following commands 
#
#   make geoinfo           - Builds geoINFO                                  
#   make all               - Builds the all geoINFO Modules 
#   make clean             - Erases intermediate files
#   make cleanall          - Erases all files produced in the build process,
#                            except the original source files

##################################################################################
#                  1 -- COMPILERS + VARIABLES                                     
##################################################################################

# This file assumes the DB2 instance path is defined by the variable HOME.
# It also assumes DB2 is installed under the DB2 instance.
# If these statements are not correct, update the variable DB2PATH. 
#DB2PATH = $(HOME)/sqllib
DB2PATH = /opt/IBM/db2/V8.1

# Use the cc compiler
CC=gcc

# The compiler options. 
DBFLAGS= $(EXTRA_CFLAGS) -I$(DB2PATH)/include -I/usr/X11R6/include -g  

# The compiler options. 
CFLAGS1= $(EXTRA_CFLAGS) -I$(DB2PATH)/include -I/usr/X11R6/include  -I/usr/include

# The compiler options. -O3
CFLAGS= $(EXTRA_CFLAGS) -I$(DB2PATH)/include -I/usr/X11R6/include -O3 -I/usr/include

# The required libraries 
LIBS= -L$(DB2PATH)/lib -Wl,-rpath,$(DB2PATH)/lib -L/usr/lib -L/usr/X11R6/lib -lXm -lXt -lm -ldb2  


# To connect to a remote SAMPLE database cataloged on the client machine
# with another name, update the DB variable.
 
# Set DBname, UID and PWD if neccesary  
DB=geoinfo
UID=geoinfo
PWD=hfh231267

COPY=cp
ERASE=rm -f
TOUCH=touch

#############################################################################
#  2 -- MAKE CATEGORIES
#              2a - make all(= allremoteclient + localclient +udfspserver)
#              2g - make clean
#              2h - make cleanall
#############################################################################


#****************************************************************************
#                  2a - make all
#****************************************************************************

all : \
	geoinfo   
	geosld

#****************************************************************************
#                  2g - make clean
#****************************************************************************

clean :	\
	cleangen \
	cleanemb
 
cleangen :
	$(ERASE) geo*.o
	$(ERASE) *.err core
	$(TOUCH) geo*.sqc geo*.c

cleanemb :
	$(ERASE) geoinfo.c
	$(ERASE) geoedit.c
	$(ERASE) geonetwork.c
	$(ERASE) geotrace.c
	$(ERASE) geosld.c
	$(ERASE) geo*.bnd


#****************************************************************************
#                  2h - make cleanall
#****************************************************************************

cleanall : \
	clean
	$(ERASE) *.bnd
	$(ERASE) geoinfo
	$(ERASE) geosld
	$(TOUCH) geo*.sqc geo*.c


#****************************************************************************
#                                  geoINFO
#****************************************************************************

geoinfo.c :    geoinfo.sqc geoinfo.h
	       db2 connect to $(DB)
	       db2 prep geoinfo.sqc bindfile
	       db2 bind geoinfo.bnd
	       db2 connect reset
	       db2 terminate

geoedit.c :    geoedit.sqc  geoinfoextern.h
	       db2 connect to $(DB)
	       db2 prep geoedit.sqc bindfile
	       db2 bind geoedit.bnd
	       db2 connect reset
	       db2 terminate

geonetwork.c : geonetwork.sqc  geoinfoextern.h
	       db2 connect to $(DB)
	       db2 prep geonetwork.sqc bindfile
	       db2 bind geonetwork.bnd
	       db2 connect reset
	       db2 terminate

geotrace.c :   geotrace.sqc  geoinfoextern.h
	       db2 connect to $(DB)
	       db2 prep geotrace.sqc bindfile
	       db2 bind geotrace.bnd
	       db2 connect reset
	       db2 terminate

geomatch.c :   geomatch.sqc  geoinfoextern.h
	       db2 connect to $(DB)
	       db2 prep geomatch.sqc bindfile
	       db2 bind geomatch.bnd
	       db2 connect reset
	       db2 terminate


geoinfo.o :       geoinfo.c
	          $(CC) -c geoinfo.c    $(CFLAGS)

geoedit.o :       geoedit.c
	          $(CC) -c geoedit.c    $(CFLAGS)

geonetwork.o :    geonetwork.c
	          $(CC) -c geonetwork.c $(CFLAGS)

geotrace.o :      geotrace.c
	          $(CC) -c geotrace.c   $(CFLAGS)

geoplot.o :       geoplot.c  geoinfoextern.h
	          $(CC) -c geoplot.c    $(CFLAGS)

geodxfio.o :      geodxfio.c  geoinfoextern.h
	          $(CC) -c geodxfio.c   $(CFLAGS)

geomatch.o :      geomatch.c  geoinfoextern.h
	          $(CC) -c geomatch.c   $(CFLAGS)

geolocate.o :     geolocate.c  geoinfoextern.h
	          $(CC) -c geolocate.c  $(CFLAGS)

geodbname.o :     geodbname.c geoinfo.h
	          $(CC) -c geodbname.c  $(CFLAGS)

geofsb.o :        geofsb.c   geoinfo.h
	          $(CC) -c geofsb.c     $(CFLAGS1)

geotransfer.o :   geotransfer.c geoinfo.h
	          $(CC) -c geotransfer.c $(CFLAGS1)

geoprojection.o : geoprojection.c  geoinfo.h
	          $(CC) -c geoprojection.c  $(CFLAGS1)

geolayer.o :      geolayer.c     geoinfo.h
	          $(CC) -c geolayer.c   $(CFLAGS)



geoinfo : geoinfo.o   geoedit.o       geonetwork.o  geotrace.o \
          geolayer.o  geoprojection.o geotransfer.o geofsb.o   \
	  geodbname.o geolocate.o     geomatch.o    geodxfio.o geoplot.o

	  $(CC) -o geoinfo      \
	           geoinfo.o    \
		   geoedit.o    \
		   geotrace.o   \
		   geonetwork.o \
		   geolayer.o   \
		   geoplot.o    \
		   geodxfio.o   \
		   geomatch.o   \
		   geolocate.o  \
		   geodbname.o  \
		   geofsb.o     \
		   geotransfer.o \
		   geoprojection.o \
	           utilemb.o $(CFLAGS) $(LIBS)



#****************************************************************************
#                             geoSLD
#****************************************************************************

geosld.c :    geosld.sqc  geoinfo.h
	      db2 connect to $(DB)
	      db2 prep geosld.sqc bindfile
	      db2 bind geosld.bnd
	      db2 connect reset
	      db2 terminate


geosld.o :    geosld.c
	      $(CC) -c geosld.c    $(CFLAGS)

geosld : geosld.o

	$(CC) -o geosld   \
	         geosld.o \
	         utilemb.o $(CFLAGS) $(LIBS)

