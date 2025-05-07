executables = xfit_var_gfort.exe
FC     = gfortran
FFLAGS = -O0 -Wall -Werror=unused-parameter -Werror=unused-variable -Werror=unused-function -Wno-maybe-uninitialized -Wno-surprising -fbounds-check -static -g -fmodule-private
obj    = kind.o constants.o util.o random.o sim_time_series.o r.o xfit_var.o

all: $(executables)

# Compile .f90 to .o
%.o: %.f90
	$(FC) $(FFLAGS) -c $<

xfit_var_gfort.exe: kind.o constants.o util.o random.o sim_time_series.o r.o xfit_var.o
	$(FC) -o xfit_var_gfort.exe kind.o constants.o util.o random.o sim_time_series.o r.o xfit_var.o $(FFLAGS)

run: $(executables)
	./xfit_var_gfort.exe

clean:
	rm -f $(executables) $(obj)

