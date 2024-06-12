#!/bin/bash

# Verificar si la carpeta ./models existe, si no, crearla
if [ ! -d "./models" ]; then
  echo "Creando la carpeta ./models..."
  mkdir -p ./models
fi

# Verificar si pip está instalado, si no, instalarlo
if ! command -v pip &> /dev/null; then
  echo "pip no está instalado. Instalándolo..."
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python get-pip.py
  rm get-pip.py
fi

# Verificar si gdown está instalado, si no, instalarlo
if ! command -v gdown &> /dev/null; then
  echo "gdown no está instalado. Instalándolo..."
  pip install gdown
fi

# Definir las IDs de los modelos en Google Drive
GDRIVE_MODEL_IDS=("1MdD47hvyO3I3gqwoEeSRmdAKpDSmdPlG"
                  "1qh0xFqo6dDdZs7uzWbEwffkVEzqlvdK5"
                  "1nIYT9BffV8eSEOOushCOcLTjjk_sP9Di")

# Descargar cada modelo desde Google Drive a la carpeta ./models
for i in "${!GDRIVE_MODEL_IDS[@]}"; do
  echo "Descargando el modelo ${i} desde Google Drive..."
  gdown "https://drive.google.com/uc?export=download&id=${GDRIVE_MODEL_IDS[$i]}" -O "./models/model_$i.zip"

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

