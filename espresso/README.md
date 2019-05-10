## Espresso


Submission scripts found here are for the openmpi complied version of espresso (espresso.sh) and intel complied version of espresso (espresso_intel.sh)

How to run them:

```bash
sbatch espresso.sh
```

```bash
sbatch espresso_intel.sh
```


### Example input file

input_file.in

* you would have to edit the pseudo_dir directive to match your folders

```bash
&control
 calculation = 'vc-relax'
 outdir = '_work'
 pseudo_dir = '/rhome/forsythc/bigdata/example-repos/qe/psp'
 prefix = 'pref'
/
&system
 ibrav = 0
 nat = 1
 ntyp = 1
 ecutwfc = 100
 occupations = 'smearing'
 smearing = 'fermi-dirac'
 degauss = 0.030

/
&electrons
 conv_thr = 1.0d-8
 mixing_mode= 'plain'
 diagonalization = 'david'
/
&ions
 ion_dynamics = 'bfgs' ! default
/
&cell
 cell_dynamics = 'bfgs' ! default
 press_conv_thr = 0.5D0 ! default
/
ATOMIC_SPECIES
 Cu 63.546 Cu_pseudo_dojo__oncv_lda.upf
CELL_PARAMETERS angstrom
 2.60 0.00 0.00
 0.00 2.60 0.00
 0.00 0.00 2.60
ATOMIC_POSITIONS crystal
 Cu 0.000 0.000 0.000
K_POINTS automatic
 6 6 6  0 0 0
```
