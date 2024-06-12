#!/bin/bash

# Verificar si la carpeta ./models existe, si no, crearla
if [ ! -d "./models" ]; then
  echo "Creando la carpeta ./models..."
  mkdir -p ./models
fi

1VHEj-vU-f4qNhCKkYODlVQIfXkCRAuHs


# Definir las URLs de los modelos en Google Drive
GDRIVE_MODEL_URLS=("https://drive.google.com/uc?export=download&id=1MdD47hvyO3I3gqwoEeSRmdAKpDSmdPlG"
                   "https://drive.google.com/uc?export=download&id=1qh0xFqo6dDdZs7uzWbEwffkVEzqlvdK5"
                   "https://drive.google.com/uc?export=download&id=1nIYT9BffV8eSEOOushCOcLTjjk_sP9Di")

# Descargar cada modelo desde Google Drive a la carpeta ./models
for i in "${!GDRIVE_MODEL_URLS[@]}"; do
  echo "Descargando el modelo ${i} desde Google Drive..."
  wget --no-check-certificate "${GDRIVE_MODEL_URLS[$i]}" -O "./models/model_$i.zip"

  # Verificar si la descarga fue exitosa
  if [ $? -eq 0 ]; then
      echo "El modelo ${i} se descargó correctamente."
      
      # Descomprimir el archivo .zip
      echo "Descomprimiendo el modelo ${i}..."
      unzip "./models/model_$i.zip" -d "./models/"
      
      # Verificar si la descompresión fue exitosa
      if [ $? -eq 0 ]; then
          echo "El modelo ${i} se descomprimió correctamente."
          # Eliminar el archivo .zip
          rm "./models/model_$i.zip"
      else
          echo "Hubo un problema al descomprimir el modelo ${i}."
          exit 1
      fi

  else
      echo "Hubo un problema al descargar el modelo ${i}."
      exit 1
  fi
done