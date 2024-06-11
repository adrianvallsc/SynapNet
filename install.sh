#!/bin/bash

# Verificar si la carpeta ./models existe, si no, crearla
if [ ! -d "./models" ]; then
  echo "Creando la carpeta ./models..."
  mkdir -p ./models
fi

# Definir la URL del modelo en Google Drive
GDRIVE_MODEL_URL="https://drive.google.com/file/d/14ALOHcHxnE8mBLqmwLKJvxFVE-lK_2TZ/view?usp=drive_link"

# Descargar el modelo desde Google Drive a la carpeta ./models
echo "Descargando el modelo desde Google Drive..."
wget --no-check-certificate "$GDRIVE_MODEL_URL" -O ./models/model.zip

# Verificar si la descarga fue exitosa
if [ $? -eq 0 ]; then
    echo "El modelo se descargó correctamente."

    # Descomprimir el archivo descargado
    echo "Descomprimiendo el archivo en ./models..."
    unzip ./models/model.zip -d ./models
    
    # Verificar si la descompresión fue exitosa
    if [ $? -eq 0 ]; then
        echo "El archivo se descomprimió correctamente."
        # Eliminar el archivo zip después de descomprimir
        rm ./models/model.zip
    else
        echo "Hubo un problema al descomprimir el archivo."
        exit 1
    fi
else
    echo "Hubo un problema al descargar el modelo."
    exit 1
fi