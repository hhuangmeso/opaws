#=====================================================================================================
#
# Makefile for creating the OPAWS analysis software
#
# Rev: 02/05/10 LJW
#      12/05/10 DCD
#      02/11/11 LJW
#
#=====================================================================================================
# You can use either netCDF3 or netCDF4.  Uncomment and set paths to these below - only one is needed

# netCDF4 libs - you need to fill in the blanks
#
NETCDFINC = -I/usr/local/netcdf4-64/include
NETCDFLIB = -L/user/local/netcdf4-64/lib -lm -lnetcdf -L/   /    /hdf5/lib -lhdf5_hl -lhdf5 -lz


# netCDF3 libs - you need to fill in the blanks
#
NETCDFINC = -I/usr/local/netcdf3-32-gfortran/include
NETCDFLIB = -L/usr/local/netcdf3-32-gfortran/lib -lnetcdf 

#=====================================================================================================
# Fortran and C compiler information - various configurations are setup, try and find one close
# 
# Generic gfortran is left to default.

#=====>> Gfortran 
# 
FC   = gfortran -m64 -g -O0 -Wl,-stack_size,10000000 -ffixed-line-length-132 -Wunused -Wuninitialized
CC   = gcc
CFLAGS = -m64 -c -g -I. -DLONG32 -DUNDERSCORE -DLITTLE -Wunused -Wuninitialized

FC   = gfortran -m32 -g -O0 -ffixed-line-length-132
CC   = gcc
CFLAGS = -m32 -c -g -I. -DLONG32 -DUNDERSCORE -DLITTLE

#=====================================================================================================
# Leave this stuff alone

EXEC = x.oban

OBJS = DART.o oban_module.o dict_module.o oban_namelist.o derived_types.o util.o fileio.o read_dorade.o binio.o v5d.o 

default: $(EXEC)

$(EXEC): $(OBJS) oban.o
	$(FC) $(OPT) -o $(EXEC) oban.o $(OBJS) $(NETCDFLIB)

clean:
	rm $(EXEC) oban.o $(OBJS) *.mod ncgen.input *.pyc sweep_file_list.txt

# Individual compilation instructions

oban.o: oban.f90 structures.inc opaws.inc DART.o
	$(FC) $(OPT) -c $(NETCDFINC) oban.f90

oban_module.o: oban_module.f90 derived_types.o opaws.inc
	$(FC) $(OPT) -c oban_module.f90

read_dorade.o: read_dorade.c read_dorade.h
	$(CC) $(CFLAGS) -c read_dorade.c

fileio.o: fileio.f90
	$(FC) $(OPT) $(NETCDFINC) -c fileio.f90

util.o: util.f opaws.inc structures.inc
	$(FC) $(OPT) -c util.f

DART.o: DART.f 
	$(FC) $(OPT) -c DART.f

derived_types.o: derived_types.f90
	$(FC) $(OPT) -c derived_types.f90

oban_namelist.o: oban_namelist.f90 opaws.inc
	$(FC) $(OPT) -c oban_namelist.f90

dict_module.o: dict_module.f90
	$(FC) $(OPT) -c dict_module.f90

binio.o: binio.c
	$(CC) $(CFLAGS) binio.c -o binio.o

v5d.o: v5d.c
	$(CC) $(CFLAGS) v5d.c -o v5d.o
