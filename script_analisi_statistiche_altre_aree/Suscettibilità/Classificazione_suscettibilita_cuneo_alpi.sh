#!/bin/sh


mappa_susc=suscettibilita_cuneo_alpi


#Suscettibilità
# r.mapcalc --overwrite "suscettibilita_cuneo_alpi = exp(est_8_finale) / (1 + exp(est_8_finale) )"

# r.mask raster=Area_calibrazione maskcats=1

# r.univar map=suscettibilita_cuneo_alpi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Suscettibilita/Cuneo_alpi/susc_cuneo_alpi_finale_IFFI.txt separator=comma

# r.mask -r

# r.univar map=suscettibilita_cuneo_alpi output=/media/sf_Tesi/Lorenzo/Script_Lorenzo/Piemonte/Suscettibilita/Cuneo_alpi/susc_cuneo_alpi_finale.txt separator=comma

limite1=1.73e-08
limite2=1.72e-07

r.mapcalc --overwrite "classi_susc_cuneo_alpi_E = if($mappa_susc<$limite1,1, if($mappa_susc<$limite2,2,3))"
r.colors map=classi_susc_cuneo_alpi_E rules=/home/lorenzo/Scrivania/GRASS/calcoli/regole_reclass/Bobbio/colori_suscettibilita.txt
exit 0
